#%%

import numpy as np
import pandas as pd
from tqdm import tqdm
from random import sample

#%%

train_data = pd.read_csv('train.csv', sep=',')  # 训练数据
train_data_matrix = np.zeros((n, m))  # 训练数据矩阵
n = 2967
m = 4125
for line in train_data.itertuples():
    train_data_matrix[line[1], line[2]] = line[3]

#%%



#%%

# K=10,alpha=0.01,lambda_j = 0.3,miu = 0.1,bu = 0.1,bm = 0.1; rsme = 0.93
# K = 30,alpha = 0.01,lambda_j = 0.3,miu = 0.1,bu = 0.1,bm = 0.1;rsme = 0.98
# K = 30，alpha = 0.01，lambda_j = 0.3，miu = 0.2，bu = 0.1，bm = 0.1；rsme = 0.91
# K = 40，alpha = 0.01，lambda_j = 0.3，miu = 0.3，bu = 0.1，bm = 0.1；rsme = 0.92
# K = 40,alpha = 0.01,lambda_j = 0.3,miu = 0.25,bu = 0.1bm = 0.1,;rsme = 0.92
# K = 20,alpha = 0.01,lambda_j = 0.3,miu = 0.2,bu = 0.1,bm = 0.1;rsme = 0.89
# K = 15,alpha = 0.01,lambda_j = 0.3,miu = 0.2,bu = 0.1,bm = 0.1;rsme = 0.898
# K = 10,alpha = 0.01,lambda_j = 0.3,miu = 0.2,bu = 0.1,bm = 0.1;for(35);rsme = 0.89
# K = 10,alpha = 0.01,lambda_j = 0.3,miu = 0.15,bu = 0.1,bm = 0.1;for(35);rsme = 0.90
# K = 30,alpha = 0.01,lambda_j = 0.3,miu = 0.15,bu = 0.1,bm = 0.1;for(20)；rsme = 0.89
# K = 10,alpha = 0.01,lambda_j = 0.3,miu = 0.15,bu = 0.1,bm = 0.1;for(35)

#%%

K = 30
alpha = 0.01
lambda_j = 0.3
miu = 0.2
bu = 0.1
bm = 0.1
F = np.random.rand(n,K)
G = np.random.rand(m,K)
def train_and_test_dictory():
    dict1 = {}#不同user各自对应的item
    dict2 = {}#不同item各自对应的user
    for i in range(0,n):
        dict1[i] = []
        for j in range(m):
            if (train_data_matrix[i][j] != 0):
                dict1[i].append(j)
                if j not in dict2.keys():
                    dict2[j] = []
                dict2[j].append(i)
    return [dict1, dict2]


lis = train_and_test_dictory()

#%%

for z in tqdm(range(40)):
    for i in lis[0].keys():
        for j in lis[0][i]:
            F[i] = (1-alpha*lambda_j) * F[i] + alpha * G[j]*(train_data_matrix[i][j] - (miu + bu + bm + np.dot(F[i],(G[j].T))))
            G[j] = (1-alpha*lambda_j) * G[j] + alpha * F[i]*(train_data_matrix[i][j] - (miu + bu + bm + np.dot(F[i],(G[j].T))))
            bu = (1-alpha*lambda_j) * bu + alpha * (train_data_matrix[i][j] - (miu + bu + bm +np.dot(F[i],(G[j].T))))
            bm = (1-alpha*lambda_j) * bm + alpha * (train_data_matrix[i][j] - (miu + bu + bm + np.dot(F[i],(G[j].T))))
    print(F)
    print(G)

    print(np.dot(F,G.T) + miu + bu + bm)
    res = np.dot(F,G.T) + miu + bu + bm
    df = pd.read_csv("test_index.csv")
    test_data_matrix = df.values

    predict_matrix = np.zeros((39679, 2))

    f = open('predict2.csv','w')
    f.write('dataID,rating\n')
    for i in range(test_data_matrix.shape[0]):
        predict_matrix[i][0] = i
        predict_matrix[i][1] = res[test_data_matrix[i][0]][test_data_matrix[i][1]]
        f.write('%d,%.8f\n'%(predict_matrix[i][0],predict_matrix[i][1]))

#%%

print(test_data_matrix.shape)

#%%

from sklearn.metrics import mean_squared_error
from math import sqrt
def rmse(prediction, ground_truth):
    prediction = prediction[ground_truth.nonzero()].flatten()
    ground_truth = ground_truth[ground_truth.nonzero()].flatten()
    return sqrt(mean_squared_error(prediction, ground_truth))
rsme_v = rmse(res,train_data_matrix)
print(rsme_v)

#%%


