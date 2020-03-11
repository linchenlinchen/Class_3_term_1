import numpy as np
import pandas as pd
from random import sample
# def run(df):
#     from sklearn import model_selection as ms
#     train_data,test_data = ms.train_test_split(df, test_size = 0.25)
#     print(df)
#     print(df.shape)
#     print(train_data.shape)
#     print(test_data)
#     print(test_data.shape)
#     print(type(train_data))

train_data = pd.read_csv('train.csv', sep=',')  # 训练数据
train_data_matrix = np.zeros((2967, 4125))  # 训练数据矩阵
for line in train_data.itertuples():
    train_data_matrix[line[1], line[2]] = line[3]

def get_dict_u():
    dict1 = {}
    dict2 = {}
    for i in range(2967):
        dict1[i] = []

        for j in range(4125):
            if train_data_matrix[i][j] != 0:
                dict1[i].append(j)
                if j not in dict2.keys():
                    dict2[j] = []
                dict2[j].append(i)
    return [dict1, dict2]


    return dict


def get_random_list(lis):
    res = sample(lis,int(len(lis) * 0.8))
    # print(res)
    return res


#   随机分配训练集和测试集
def get_random_dict(dict_list):
    train_u = {}
    train_i = {}
    test_u = {}
    test_i = {}
    dict_u = dict_list[0]
    # dict_i = dict_list[1]
    #  对每个用户随机取80%训练集
    for key in dict_u.keys():
        #  随机取80%
        lis = get_random_list(dict_u[key])
        train_u[key] = lis
        test_u[key] = list(set(dict_u[key]) - set(lis))
        for i in lis:
            if i in train_i.keys():
                train_i[i].append(key)
            else:
                train_i[i] = [int(key)]
        for j in test_u[key]:
            if j in test_i.keys():
                test_i[j].append(int(key))
            else:
                test_i[j] = [int(key)]
    return [train_u, test_u, train_i, test_i]


def get_rmse(G_o, G_train,dict):
    add = 0.0
    row = G_o.shape[0]
    col = G_o.shape[1]
    a = 0
    for i in range(row):
        for j in dict[i]:
            add += np.square(G_o[i][j] - G_train[i][j])
            a += 1
    return np.sqrt(add / a)


def get_test_rmse(train_result, test_mat, dict):
    add = 0.0
    row = train_result.shape[0]
    col = train_result.shape[1]
    a = 0
    for i in range(row):
        lis = dict[i]
        for j in lis:
            add += np.square(train_result[i][j] - test_mat[i][j])
            a += 1
    return np.sqrt(add / a)

# F躺着，G躺着
def updateF(lbd, G, F, train_data_matrix):
    N = F.shape[1]
    K = F.shape[0]
    trans_F = np.transpose(F)
    trans_F_copy = np.zeros((N,K))
    for i in range(N):
        for j in range(K):
            trans_F_copy[i][j] = trans_F[i][j]
    trans_G = np.transpose(G)
    for i in range(N):
        # Wi,m=1的所有m
        index = np.nonzero(train_data_matrix[i])
        gg_sum = np.zeros((K, K))
        gx_sum = np.zeros((K, 1))
        for j in index[0]:
            gg_sum += np.array([trans_G[j]]).T * np.array([trans_G[j]])
        # print(gg_sum)
        for z in index[0]:
            gx_sum += np.array([trans_G[z]]).T * train_data_matrix[i][z]
        # print(gx_sum)
        # 是否会是奇异矩阵而不能求逆矩阵呢？
        # print(np.linalg.inv(lbd * np.identity(K) + gg_sum))
        # print(gx_sum)
        # print(np.dot(np.linalg.inv(lbd * np.identity(K) + gg_sum), gx_sum).T)
        trans_F_copy[i] = np.array(np.dot(np.linalg.inv(lbd * np.identity(K) + gg_sum), gx_sum).T).reshape(K)
    return trans_F_copy.T


# F躺着，G躺着
def updateG(lbd, G, F, train_data_matrix):
    train_data_matrix_tran = np.transpose(train_data_matrix)
    M = G.shape[1]
    K = G.shape[0]
    trans_F = np.transpose(F)
    trans_G = np.transpose(G)
    trans_G_copy = np.zeros((M, K))
    for i in range(M):
        for j in range(K):
            trans_G_copy[i][j] = trans_G[i][j]
    for i in range(M):
        # Wi,m=1的所有m
        index = np.nonzero(train_data_matrix_tran[i])
        ff_sum = np.zeros((K, K))
        fx_sum = np.zeros((K, 1))
        for j in index[0]:
            ff_sum += np.array([trans_F[j]]).T * np.array([trans_F[j]])
        # print(gg_sum)
        for z in index[0]:
            fx_sum += np.array([trans_F[z]]).T * train_data_matrix_tran[i][z]
        # print(gx_sum)
        # 是否会是奇异矩阵而不能求逆矩阵呢？
        # print(np.linalg.inv(lbd * np.identity(K) + gg_sum))
        # print(gx_sum)
        # print(np.dot(np.linalg.inv(lbd * np.identity(K) + gg_sum), gx_sum).T)
        trans_G_copy[i] = np.array(np.dot(np.linalg.inv(lbd * np.identity(K) + ff_sum), fx_sum).T).reshape(K)
    return trans_G_copy.T


def updateF_train(lbd, G, F, train_data_matrix, dict):
    N = F.shape[1]
    K = F.shape[0]
    trans_F = np.transpose(F)
    trans_F_copy = np.zeros((N, K))
    for i in range(N):
        for j in range(K):
            trans_F_copy[i][j] = trans_F[i][j]
    trans_G = np.transpose(G)
    # print(trans_G.shape)
    for i in range(N):
        # Wi,m=1的所有m
        index = dict[i]
        gg_sum = np.zeros((K, K))
        gx_sum = np.zeros((K, 1))
        for j in index:
            gg_sum += np.array([trans_G[j]]).T * np.array([trans_G[j]])
            gx_sum += np.array([trans_G[j]]).T * train_data_matrix[i][j]
        # print(gg_sum)
        # for z in index:
        #     gx_sum += np.array([trans_G[z]]).T * train_data_matrix[i][z]
        # print(gx_sum)
        # 是否会是奇异矩阵而不能求逆矩阵呢？
        # print(np.linalg.inv(lbd * np.identity(K) + gg_sum))
        # print(gx_sum)
        # print(np.dot(np.linalg.inv(lbd * np.identity(K) + gg_sum), gx_sum).T)
        trans_F_copy[i] = np.array(np.dot(np.linalg.inv(lbd * np.identity(K) + gg_sum), gx_sum).T).reshape(K)
    return trans_F_copy.T


def updateG_train(lbd, G, F, train_data_matrix, dict):
    train_data_matrix_tran = np.transpose(train_data_matrix)
    M = G.shape[1]
    K = G.shape[0]
    trans_F = np.transpose(F)
    trans_G = np.transpose(G)
    trans_G_copy = np.zeros((M, K))
    for i in range(M):
        for j in range(K):
            trans_G_copy[i][j] = trans_G[i][j]
    for i in range(M):
        # Wi,m=1的所有m
        if i not in dict.keys():
            trans_G_copy[i] = 0
            continue
        index = dict[i]
        ff_sum = np.zeros((K, K))
        fx_sum = np.zeros((K, 1))
        for j in index:
            ff_sum += np.array([trans_F[j]]).T * np.array([trans_F[j]])
            fx_sum += np.array([trans_F[j]]).T * train_data_matrix_tran[i][j]
        # print(gx_sum)
        # 是否会是奇异矩阵而不能求逆矩阵呢？
        # print(np.linalg.inv(lbd * np.identity(K) + gg_sum))
        # print(gx_sum)
        # print(np.dot(np.linalg.inv(lbd * np.identity(K) + gg_sum), gx_sum).T)
        trans_G_copy[i] = np.array(np.dot(np.linalg.inv(lbd * np.identity(K) + ff_sum), fx_sum).T).reshape(K)
    return trans_G_copy.T


def get_train_or_test_mat(dict_train_or_test, origin_matrix):
    user_number = origin_matrix.shape[0]
    item_number = origin_matrix.shape[1]
    back = np.zeros((user_number, item_number))
    for i in dict_train_or_test.keys():
        for j in dict_train_or_test[i]:
            back[i][j] = origin_matrix[i][j]
    return back


def get_distance(a,b):
    add = 0.0
    row = a.shape[0]
    col = a.shape[1]
    c = row*col
    for i in range(row):
        for j in range(col):
            add += np.square(a[i][j] - b[i][j])
    return np.sqrt(add/c)


if __name__ == "__main__":
    # run(train_data_matrix)
    import time
    from tqdm import tqdm
    #  k, rsme
    res = [0,10]
    t1 = time.time()
    #  获得user和item纬度的字典--实际上是一样的，只是为了便于查找
    dict_list = get_dict_u()
    dict1 = dict_list[0]
    dict2 = dict_list[1]
    result = get_random_dict(dict_list)  # 划分
    # print(result)  #  训练用户字典，测试用户字典，训练产品字典，测试产品字典
    train_u = result[0]
    test_u = result[1]
    train_i = result[2]
    test_i = result[3]

    train1_mat = get_train_or_test_mat(train_u, train_data_matrix)
    test1_mat = get_train_or_test_mat(test_u, train_data_matrix)

    for K in tqdm(range(11,12)):
        F = np.full((K, 2967), 0.5)
        G = np.full((K, 4125), 0.5)

        while 1 == 1:
            new_F = updateF_train(0.2, G, F, train1_mat, train_u)
            new_G = updateG_train(0.2, G, new_F, train1_mat, train_i)
            dis1 = get_distance(new_F, F)
            dis2 = get_distance(new_G, G)
            # print("dis1:", dis1)
            # print("dis2:", dis2)
            if dis1 < 0.01 and dis2 < 0.01:
                break
            F = new_F
            G = new_G
        result_mat = np.dot(F.T,G)
        # print("result_mat:", result_mat.shape)
        # print("best rmse:", res[1])
        rmse = get_test_rmse(result_mat, test1_mat,test_u)
        print("rmse:",rmse)
        if rmse < res[1]:
            res[0] = K
            res[1] = rmse

    #     print("now best K:", res[0])
    #     print("now best rmse:",res[1])
    # print("result K:",res[0])
    # print("result rmse:",res[1])

    df = pd.read_csv("test_index.csv")
    test_data_matrix = df.values
    predict_matrix = np.zeros((39679, 2))
    for i in range(test_data_matrix.shape[0]):
        predict_matrix[i][0] = i
        predict_matrix[i][1] = result_mat[test_data_matrix[i][0]][test_data_matrix[i][1]]
    # print(predict_matrix)
    df = pd.DataFrame({"dataID": predict_matrix.T[0], "rating": predict_matrix.T[1]})
    df.to_csv("predict_als.csv", index=False)
