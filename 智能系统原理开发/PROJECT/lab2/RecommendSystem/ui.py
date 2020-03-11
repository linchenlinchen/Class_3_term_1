# %%

import numpy as np
import pandas as pd

# %%

df = pd.read_csv('train.csv')
# print(df)

# %%

n_users = df.userID.unique().shape[0]
n_items = df.loc[:, ['itemID']].max()['itemID'] + 1
# print(n_items)
# print(type(n_items))
# print('number of user is '+ str(n_users) + ' | Number of item = ' + str(n_items))

# %%

# from sklearn import model_selection as ms
# train_data,test_data = ms.train_test_split(df, test_size = 0.25)
# print(df)
# print(train_data)
# print(type(train_data))
# print(train_data.shape)
# print(test_data.shape)

# %%

train_data_matrix = np.zeros((n_users, n_items))
for line in df.itertuples():
    # print(line)
    train_data_matrix[int(line[1]), int(line[2])] = line[3]
# print(train_data_matrix)
# train_data_matrix[:, 0] += 1e-9
# train_data_matrix[0] += 1e-9
# test_data_matrix = np.zeros((n_users, n_items))
# for line in test_data.itertuples():
#    test_data_matrix[line[1]-1, line[2]-1] = line[3]
# test_data_matrix[:,0]+=1e-9
# test_data_matrix[0]+=1e-9

# %%

# from sklearn.metrics.pairwise import pairwise_distances
# user_similarity = pairwise_distances(train_data_matrix, metric = "cosine")
# item_similarity = pairwise_distances(train_data_matrix.T, metric = "cosine")
# print(user_similarity)

# %%

import time
from tqdm import tqdm


# %%

def count_user_similarity(train_data_matrix):
    num_user = train_data_matrix.shape[0]
    pss_user = np.ones((num_user, num_user))
    mean_user = np.average(train_data_matrix, 1, weights=np.int64(train_data_matrix > 0))  # 求平均值
    for i in tqdm(range(num_user)):  # 进度条
        for j in range(i, num_user):
            if i == j:
                pss_user[i][j] = 1
            else:
                # 筛选共同打分的item索引
                ind = np.nonzero(train_data_matrix[i] * train_data_matrix[j])
                # 计算相似度
                t = (np.sqrt(np.sum(np.square(train_data_matrix[i][ind] - mean_user[i]))) * np.sqrt(np.sum(np.square(train_data_matrix[j][ind] - mean_user[j]))))
                if t == 0:
                    pss_user[i][j] = pss_user[j][i] = 0
                else:
                    pss_user[i][j] = pss_user[j][i] = np.sum((train_data_matrix[i][ind] - mean_user[i]) * (train_data_matrix[j][ind] - mean_user[j]))/t
    return pss_user


# %%




# %%

def count_item_similarity(train_data_matrix):
    train_data_matrix_T = np.transpose(train_data_matrix)
    num_item = train_data_matrix_T.shape[0]
    # print(num_item)
    pss_item = np.zeros((num_item, num_item))
    # mean_item = np.average(train_data_matrix,0,weights=np.int64(train_data_matrix>0))#求平均值
    # print(mean_item)
    for i in tqdm(range(num_item)):
        for j in range(i, num_item):
            if i == j:
                pss_item[i][j] = 1
            else:
                # 筛选共同打分的item索引
                ind = np.nonzero(train_data_matrix_T[i] * train_data_matrix_T[j])
                # if len(ind[0])==1:
                #    pss_item[i][j]=0
                # continue
            # 计算相似度
                t = (np.sqrt(np.sum(np.square(train_data_matrix_T[i][ind]))) * np.sqrt(np.sum(np.square(train_data_matrix_T[j][ind]))))
                if t == 0:
                    pss_item[i][j] = pss_item[j][i] = 0
                else:
                    pss_item[i][j] = pss_item[j][i] = np.sum((train_data_matrix_T[i][ind]) * (train_data_matrix_T[j][ind]))/ t
    return pss_item



# %%

def mean_nozero(ratings, kind):
    if kind == 'user':
        user_bias = np.zeros(ratings.shape[0])
        for i in range(0, ratings.shape[0]):
            number = amount = 0
            for j in range(0, ratings.shape[1]):
                if (ratings[i, j] != 0):
                    number += 1
                    amount += ratings[i, j]
            user_bias[i] = amount / number
        return user_bias
    if kind == 'item':
        item_bias = np.zeros(ratings.shape[1])
        for i in range(0, ratings.shape[1]):
            number = amount = 0
            for j in range(0, ratings.shape[0]):
                if (ratings[j, i] != 0):
                    number += 1
                    amount += ratings[j, i]
            item_bias[i] = amount / number
        return item_bias


# %%

def predict_topk_nobias(ratings, similarity, kind='user', k=40):
    tmp1 = np.zeros(ratings.shape)
    tmp2 = np.zeros(ratings.shape[0])
    pred = np.zeros(ratings.shape)
    if kind == 'user':
        # user_bias = ratings.mean(axis=1)#按行求平均值
        train_T = train_data_matrix.T
        user_bias = mean_nozero(ratings, 'user')
        similarity_sub = similarity - np.identity(n_users)
        pred = np.zeros((n_users,n_items))
        for i in tqdm(range(n_users)):
            for j in range(n_items):
                if train_data_matrix[i][j] == 0:
                    ind = np.nonzero(similarity_sub[i] * train_T[j])
                    below = np.sum(np.fabs(similarity_sub[i][ind]))
                    if below == 0:
                        below += 1e-8
                    pred[i][j] = user_bias[i] + np.sum(
                        similarity[i][ind] * (train_T[j][ind] - user_bias[ind])) / below
                    if pred[i][j] > 5:pred[i][j] = 5
                    elif pred[i][j] < 0:pred[i][j] = 0
                else:
                    pred[i][j] = train_data_matrix[i][j]
            print(pred[i])
    if kind == 'item':
        # item_bias = ratings.mean(axis=0)
        train_T = train_data_matrix.T
        similarity_sub = similarity- np.identity(n_items)
        pred = np.zeros((n_users,n_items))
        for i in tqdm(range(n_items)):
            for j in range(n_users):
                if train_T[i][j] == 0:
                    ind = np.nonzero(similarity_sub[i] * train_data_matrix[j])
                    below = np.sum(np.fabs(similarity_sub[i][ind]))
                    if below == 0:
                        below += 0.0000001
                    pred[i][j] = np.sum(similarity_sub[i][ind] * train_data_matrix[j][ind]) / below
                    # 修正预测打分结果
                    if pred[i][j] > 5:pred[i][j] = 5
                    elif pred[i][j] < 0:pred[i][j] = 0
                else:
                    pred[i][j] = train_T[i][j]
    return pred


# %%

def predict(rating, similarity, type='user'):
    if (type == 'user'):
        mean_user_rating = rating.mean(axis=1)
        print(mean_user_rating)
        rating_diff = (rating - mean_user_rating[:, np.newaxis])
        # pred = mean_user_rating[:,np.newaxis] + similarity.dot(rating_diff) / np.array([np.abs(similarity).sum(axis=1)]).T
    elif type == 'item':
        print(rating.shape)
        print(similarity.shape)
        # pred = rating.dot(similarity) / np.array([np.abs(similarity).sum(axis=1)])
    # return pred


# %%


# %%
if __name__ == "__main__":
    pss_item = count_item_similarity(train_data_matrix)
    print("pss item:",pss_item)
    print(pss_item.shape)
    item_based_pred = predict_topk_nobias(train_data_matrix, pss_item, 'item', 40)
    print(item_based_pred)

    df = pd.read_csv("test_index.csv")
    test_data_matrix = df.values

    predict_matrix = np.zeros((39679, 2))

    f = open('predict-item-jj.csv', 'w')
    f.write('dataID,rating\n')
    for i in range(test_data_matrix.shape[0]):
        predict_matrix[i][0] = i
        predict_matrix[i][1] = item_based_pred[test_data_matrix[i][0]][test_data_matrix[i][1]]
        f.write('%d,%.8f\n' % (predict_matrix[i][0], predict_matrix[i][1]))

    pss_user = count_user_similarity(train_data_matrix)
    print("pss user:",pss_user)
    user_based_pred = predict_topk_nobias(train_data_matrix, pss_user, 'user', 40)

    df = pd.read_csv("test_index.csv")
    test_data_matrix = df.values

    predict_matrix = np.zeros((39679, 2))

    f = open('predict-user-jj.csv', 'w')
    f.write('dataID,rating\n')
    for i in range(test_data_matrix.shape[0]):
        predict_matrix[i][0] = i
        predict_matrix[i][1] = user_based_pred[test_data_matrix[i][0]][test_data_matrix[i][1]]
        f.write('%d,%.8f\n' % (predict_matrix[i][0], predict_matrix[i][1]))
    # print("user_pred:",user_based_pred)
    #
    # # %%
    #
    # print(user_based_pred.shape)

    # %%

    # df_user_result = pd.DataFrame(user_based_pred)
    # # print(df_result)
    # df_user_result.to_csv('user_based_result.csv', index=None)

    # %%



    # %%

    # f = open('predict2.csv', 'w')
    # f.write('dataID,rating\n')
    # for i in range(test_data_matrix.shape[0]):
    #     predict_matrix[i][0] = i
    #     predict_matrix[i][1] = res[test_data_matrix[i][0]][test_data_matrix[i][1]]
    #     f.write('%d,%.8f\n' % (predict_matrix[i][0], predict_matrix[i][1]))

    # %%

    df_item_result = pd.DataFrame(item_based_pred)
    # print(df_result)
    df_item_result.to_csv('result-cfitem-jj.csv', index=None)

    # %%

    from sklearn.metrics import mean_squared_error
    from math import sqrt


def rmse(prediction, ground_truth):
    prediction = prediction[ground_truth.nonzero()].flatten()
    ground_truth = ground_truth[ground_truth.nonzero()].flatten()
    return sqrt(mean_squared_error(prediction, ground_truth))


# %%

df_test = pd.read_csv('test_index.csv')
print(df_test)  # 这里为什么没有打分？

# %%

# n_users_test = df.userID.unique().shape[0]
# n_items_test = df.loc[:,['itemID']].max()['itemID']
# test_data_matrix = np.zeros(n_users, n_items)
# for line in df_test.itertuples():
#    test_data_matrix[int(line[1])-1, int(line[2])-1] =
# precise = rmse(user_based_pred,test_data_matrix)
# print(precise)

# %%

# df_test = df_test.values
# precise = rmse(user_based_pred,test_data_matrix)
# print(precise)

# %%


