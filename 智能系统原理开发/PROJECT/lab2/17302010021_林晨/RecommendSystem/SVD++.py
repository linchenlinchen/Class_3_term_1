import numpy as np
import pandas as pd
from tqdm import tqdm
from random import sample
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

if __name__ == "__main__":
    K = 4
    alpha = 0.01
    # lbd = 0.3
    miu = 0.1
    bu = 0.1
    bm = 0.1
    F = np.random.rand(2967,K)
    G = np.random.rand(4125,K)

    lis = get_dict_u()
    for m in range(1,10):
        alpha = 0.005 * m
        for l in range(1,20):
            lbd = 0.1 * l
            for z in tqdm(range(500)):
                for i in lis[0].keys():
                    for j in lis[0][i]:
                        F[i] = (1-alpha*lbd)*F[i] + alpha*G[j]*(train_data_matrix[i][j] - (miu + bu + bm + np.dot(F[i],(G[j].T))))
                        G[j] = (1-alpha*lbd)*G[j] + alpha*F[i]*(train_data_matrix[i][j] - (miu + bu + bm + np.dot(F[i],(G[j].T))))
                        bu = (1-alpha*lbd)*bu + alpha*(train_data_matrix[i][j] - (miu + bu + bm +np.dot(F[i],(G[j].T))))
                        bm = (1-alpha*lbd)*bm + alpha*(train_data_matrix[i][j] - (miu + bu + bm + np.dot(F[i],(G[j].T))))
                        # print(F[i])
                        # print(G[j])
                        # F[i] = fi
                        # G[j] = gj
                        # bu = bu_t
                        # bm = bm_t
                print(F)
                print(G)

                print(np.dot(F,G.T) + miu + bu + bm)
                if z == 499:
                    res = np.dot(F,G.T) + miu + bu + bm
                    df = pd.read_csv("test_index.csv")
                    test_data_matrix = df.values

                    predict_matrix = np.zeros((39679, 2))
                    for i in range(test_data_matrix.shape[0]):
                        predict_matrix[i][0] = i
                        predict_matrix[i][1] = res[test_data_matrix[i][0]][test_data_matrix[i][1]]
                    # print(predict_matrix)
                    df = pd.DataFrame({"dataID": predict_matrix.T[0], "rating": predict_matrix.T[1]})
                    df.to_csv("predict-lbd"+str(l)+"alpha"+str(m)+".csv", index=False)

