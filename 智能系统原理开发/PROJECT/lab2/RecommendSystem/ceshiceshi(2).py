import numpy as np
import pandas as pd
train_data = pd.read_csv('./train.csv', sep = ',')

train_data_matrix = np.zeros((2967,4125))
for line in train_data.itertuples():
    train_data_matrix[line[1], line[2]] = line[3]

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
            if i==j :
                pss[i][j]=1
            else :
                #筛选共同打分的item索引
                ind = np.nonzero(train_data_matrix[i]*train_data_matrix[j])
#                 if len(ind[0])==1:
#                     pss[i][j]=0
#                     continue
                #计算相似度
                pss[i][j]=pss[i][j]=np.sum((train_data_matrix[i][ind]-mean_user[i])*(train_data_matrix[j][ind]-mean_user[j]))/(np.sqrt(np.sum(np.square(train_data_matrix[i][ind]-mean_user[i])))*np.sqrt(np.sum(np.square(train_data_matrix[j][ind]-mean_user[j]))))

except KeyboardInterrupt:
    tqdm.close()
    raise
t2=time.time()
print(t2-t1)