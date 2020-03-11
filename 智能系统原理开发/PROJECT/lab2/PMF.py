import numpy as np
import pandas as pd
from random import sample
train_data = pd.read_csv('train.csv', sep=',')  # 训练数据
train_data_matrix = np.zeros((2967, 4125))  # 训练数据矩阵
for line in train_data.itertuples():
    train_data_matrix[line[1], line[2]] = line[3]

# def get
def get_dict_u():
    dict = {}
    for i in range(2967):
        dict[i] = []
        for j in range(4125):
            if train_data_matrix[i][j] is np.nan:
                train_data_matrix[i][j] = 0
            if train_data_matrix[i][j] != 0:
                dict[i].append(j)
    print(dict)
    return dict
# 生成某区间内不重复的N个随机数的方法
import random;

def get_random_train_index():
    # 利用Python中的randomw.sample()函数实现
    A = 0  # 最小随机数
    B = 2967  # 最大随机数
    COUNT = 2300 #约 80% 的训练集

    resultList = random.sample(range(A, B + 1), COUNT)  # sample(x,y)函数的作用是从序列x中，随机选择y个不重复的元素。上面的方法写了那么多，其实Python一句话就完成了。
    print(resultList)  # 打印结果
    import csv
    df = pd.DataFrame(resultList)
    df.to_csv("random_index.csv",header=True,index=True)
    return resultList
def get_random_list(lis):
    res = sample(lis,len(lis) * 0.8)
    print(res)
    return res


def get_rmse(G_o, G_train):
    add = 0.0
    row = G_o.shape[0]
    col = G_o.shape[1]
    a = row * col
    for i in range(row):
        for j in range(col):
            add += np.square(G_o[i][j] - G_train[i][j])
    return np.sqrt(add / a)


def get_random_rmse(G_o, G_train, dict):
    add = 0.0
    row = G_o.shape[0]
    col = G_o.shape[1]
    a = 0
    for i in range(row):
        lis = dict[i]
        res = get_random_list(lis)
        for j in res:
            add += np.square(G_o[i][j] - G_train[i][j])
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
def updateG(lbd, F, G, train_data_matrix):
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


if __name__ == "__main__":
    import time
    from tqdm import tqdm
    res = [0,0,0]
    t1 = time.time()
    for K in tqdm(range(1, 100)):
        F = np.full((K, 2967), 0.5)
        G = np.full((K, 4125), 0.5)
        dict = get_dict_u()
        while 1 == 1:
            new_F = updateF(1, G, F, train_data_matrix)
            new_G = updateG(1, new_F, G, train_data_matrix)
            if get_rmse(new_F, F) < 0.01 and get_rmse(new_G, G) < 0.01:
                break
            F = new_F
            G = new_G
        print(np.dot(F.T,G))
        # if()
        # res[0] = K
    # print(updateG(0.1, np.array([[0.3,0.7],[0.4,0.6]]), np.array([[0.9, 0.1], [0.8,0.2]]), np.array([[3,4],[2,2]])))
    # a = np.zeros((2, 2967))
    # for i in range(2):
    #     for j in range(2967):
    #         a[i, j] = i+j
    # rst = np.zeros((a.shape[0], a.shape[0]))
    # print(rst.shape)
    # ind = np.nonzero(train_data_matrix[1])  # 各个用户u打分了的电影id
    # trans_G = a.T  # 立着
    # print(ind)
    # for i in ind[0]:
    #     # print(trans_G.shape)
    #     # print(1)
    #     # # print(a[i])
    #     # print(np.array(trans_G[i]).T)
    #     rst += np.array([trans_G[i]]).T * np.array([trans_G[i]])
    # print(rst)
