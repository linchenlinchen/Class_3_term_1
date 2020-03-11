import numpy as np
import pandas as pd
train_data = pd.read_csv('train.csv', sep=',')
train_data_matrix = np.zeros((2967,4125))
for line in train_data.itertuples():
    train_data_matrix[line[1], line[2]] = line[3]
print(train_data_matrix)
import time
from tqdm import tqdm
t1=time.time()
num_user=train_data_matrix.shape[0]
pss=np.zeros((num_user,num_user))
#保存用户评分的均值
mean_user = np.average(train_data_matrix,1,weights=np.int64(train_data_matrix>0))
try:
    for i in tqdm(range(num_user)):
        for j in range(i,num_user):
            if i == j:
                pss[i][j]=1
            else :
                #筛选共同打分的item索引
                ind = np.nonzero(train_data_matrix[i]*train_data_matrix[j])
                if len(ind[0])==1:
                    pss[i][j]=0
                    continue
                #计算相似度
                down1 = np.sqrt(np.sum(np.square(train_data_matrix[i][ind]-mean_user[i])))
                down2 = np.sqrt(np.sum(np.square(train_data_matrix[j][ind]-mean_user[j])))
                if down1 != 0 and down2 != 0:
                    pss[i][j] = pss[j][i]=np.sum((train_data_matrix[i][ind]-mean_user[i])*(train_data_matrix[j][ind]-mean_user[j]))/ (down1*down2)
                elif down1 == 0 and down2 == 0:
                    pss[i][j] = 1
                else:
                    pss[i][j] = 0

    # !/usr/bin/python
    # -*- coding:utf-8 -*-

    import csv
    df = pd.DataFrame(pss)
    df.to_csv("user_based_similar.csv",header=True,index=True)
except KeyboardInterrupt:
    tqdm.close()
    raise
t2=time.time()
print(t2-t1)