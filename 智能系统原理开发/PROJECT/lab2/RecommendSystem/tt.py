# %%

import numpy as np
import pandas as pd
import time
from tqdm import tqdm

# %%

df = pd.read_csv('train.csv')
n_users = df.userID.unique().shape[0]
n_items = df.loc[:, ['itemID']].max()['itemID'] + 1
print(n_users)
print(n_items)
print('number of user is ' + str(n_users) + ' | Number of item = ' + str(n_items))

# %%

from sklearn import model_selection as ms

train_data, test_data = ms.train_test_split(df, test_size=0.25)
train_data_matrix = np.zeros((n_users, n_items))
test_data_matrix = np.zeros((n_users, n_items))
# print(train_data_matrix.shape)
for line in train_data.itertuples():
    # print(line)
    train_data_matrix[int(line[1]), int(line[2])] = line[3]
for line in test_data.itertuples():
    # print(line)
    test_data_matrix[int(line[1]), int(line[2])] = line[3]

# train_data_matrix[:,0] += 1e-9;
# train_data_matrix[0] += 1e-9
# test_data_matrix[:,0] += 1e-9;
# test_data_matrix[0] += 1e-9;

# %%

import time
from tqdm import tqdm

# %%

connect_user_item = np.zeros((n_users, n_items))
# connect_user_item[connect_user_item != 0] = 1;
for i in range(0, n_users):
    for j in range(0, n_items):
        if (train_data_matrix[i, j] != 0):
            connect_user_item[i, j] = 1;
print(connect_user_item.shape)
# print(train_data_matrix)

# %%




# print(type(f_users[0]))
# print(f_users.shape)
# print(sum(f_users[2]))

# %%

# tmp1 = np.zeros((n_users, n_features))
# tmp2 = np.zeros(n_users)
# for i in tqdm(range(0, n_users)):
#    for j in range(0, n_items):
#       if(train_data_matrix[i,j] != 0):
#            tmp1[i] = tmp1[i] + train_data_matrix[i][j] * f_items[i]
#            tmp2[i] = tmp2[i] + np.dot(f_items[j], f_items[j])
# for i in tqdm(range(0, n_users)):
#    f_users[i] = tmp1[i] / ( tmp2[i]+landar)

# %%

def count_f_users():
    # f_users = np.full((n_users, n_features),0.5)
    # f_items = np.full((n_items, n_features),0.5)
    # tmp1 = np.zeros((n_features, 1))
    # tmp2 = np.zeros((n_features,n_features))
    for i in range(0, n_users):
        tmp1 = np.zeros((1, n_features))
        tmp2 = np.zeros((n_features, n_features))
        for j in range(0, n_items):
            if train_data_matrix[i, j] != 0:
                # print(f_items)
                # print(f_items[j].shape)
                # print(train_data_matrix[i][j])
                # print((train_data_matrix[i][j] * (np.array([f_items[j]]))).shape)
                # print(tmp1.shape)
                tmp1 += train_data_matrix[i][j] * np.array([f_items[j]])
                tmp2 += np.dot(np.array([f_items[j]]).T, np.array([f_items[j]]))
        # print(tmp2)
        f_users[i] = np.array((np.dot(np.linalg.inv(tmp2 + landar * np.identity(n_features)), tmp1.T)).T).reshape(n_features)
    return f_users


# %%

# print(count_f_users(n_users, n_items, 3, ))

# %%

# tmp3 = np.zeros((n_items, n_features))
# tmp4 = np.zeros(n_items)
# for i in tqdm(range(0, n_users)):
#    for j in range(0, n_items):
#        if(train_data_matrix[i,j] != 0):
#            tmp3[j] = tmp3[j] + train_data_matrix[i,j] * f_users[i]
#            tmp4[j] = tmp4[j] + np.dot(f_users[i], f_users[i])
# for i in tqdm(range(0, n_items)):
#    f_items[i] = tmp3[i] / ( tmp4[i] + landar)

# %%

def count_f_items():
    # f_items = np.full((n_items, n_features),0.5)
    # f_users = np.full((n_users, n_features),0.5)
    for j in range(0, n_items):
        tmp3 = np.zeros((1, n_features))
        tmp4 = np.zeros((n_features, n_features))
        for i in range(0, n_users):
            if train_data_matrix[i, j] != 0:
                tmp3 += train_data_matrix[i, j] * np.array([f_users[i]])
                tmp4 += np.dot(np.array([f_users[i]]).T, np.array([f_users[i]]))
        f_items[j] = np.array(np.dot(np.linalg.inv(tmp4 + landar * np.identity(n_features)), tmp3.T).T).reshape(n_features)
    return f_items


# %%

# print(count_f_items(n_users, n_items, 3))

# %%
if __name__ == "__main__":
    n_features = 3  # 参数
    f_users = np.full((n_users, n_features), 0.5)
    f_items = np.full((n_items, n_features), 0.5)
    landar = 0.5
    for i in tqdm(range(50)):
        f_users = count_f_users()
        f_items = count_f_items()

        print(np.dot(f_users, f_items.T))
    res = np.dot(f_users, f_items.T)
    test_df = pd.read_csv("test_index.csv")
    test_data_matrix = test_df.values

    predict_matrix = np.zeros((39679, 2))

    for i in range(test_data_matrix.shape[0]):
        predict_matrix[i][0] = int(i)
        predict_matrix[i][1] = res[test_data_matrix[i][0]][test_data_matrix[i][1]]
    predict_df = pd.DataFrame({"dataID": predict_matrix.T[0], "rating": predict_matrix.T[1]})
    predict_df.to_csv("predict-pmf-jj.csv", index=False)
# %%

# print(f_users)
# print(f_items)
# print(np.dot(f_users, f_items.T))

# %%

# prediction = np.zeros(n_users, n_items)
# prediction = np.dot(f_users, f_items.T)
# prediction[prediction < 0.5] = 0.5
# prediction[prediction > 5] = 5
# print(prediction)

# %%


# print(predict_matrix)


# predict_df = pd.DataFrame({"dataID": predict_matrix.T[0], "rating": predict_matrix.T[1]})
# predict_df.to_csv("predict.csv", index=False)

# %%

from sklearn.metrics import mean_squared_error
from math import sqrt


def rmse(prediction, ground_truth):
    prediction = prediction[ground_truth.nonzero()].flatten()
    ground_truth = ground_truth[ground_truth.nonzero()].flatten()
    return sqrt(mean_squared_error(prediction, ground_truth))

# %%

# delta = 1
# best_k = -1
# result_with_test = 100
# best_result = 100
# for i in tqdm(range(10,20)):
#     while(delta > 0.1):
#         print(i)
#         f_users = np.zeros((n_users, i))
#         f_items = np.zeros((n_items, i))
#         f_users = count_f_users(n_users, n_items, i)
#         f_items = count_f_items(n_users, n_items, i)
#         prediction = np.dot(f_users, f_items.T)
#         delta = rmse(prediction, train_data_matrix)
#         print(delta)
#     result_with_test = rmse(prediction, test_data_matrix)
#     if(result_with_test < best_result):
#         best_result = result_with_test
#         best_k = i
#         print("best_k changed " + i)
# print(i)

# %%

# print(i)

# %%
