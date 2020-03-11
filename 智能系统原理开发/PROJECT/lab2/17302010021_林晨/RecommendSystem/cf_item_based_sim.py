import numpy as np
import pandas as pd
train_data = pd.read_csv('train.csv', sep=',')
train_data_matrix = np.zeros((2967,4125))
for line in train_data.itertuples():
    train_data_matrix[line[1], line[2]] = line[3]
train_data_transpose_matrix = np.transpose(train_data_matrix)
import time
from tqdm import tqdm
t1=time.time()
num_items = train_data_matrix.shape[1]
pss=np.zeros((num_items,num_items))
try:
    for i in tqdm(range(num_items)):
        for j in range(i,num_items):
            # 筛选共同打分的item索引
            if i == j:
                pss[i][j] = 1
            else:
                ind = np.nonzero(train_data_transpose_matrix[i] * train_data_transpose_matrix[j])
                # print(ind)
                # 计算相似度
                down1 = np.sqrt(np.sum(np.square(train_data_transpose_matrix[i][ind])))
                down2 = np.sqrt(np.sum(np.square(train_data_transpose_matrix[j][ind])))
                if down1 != 0 and down2 != 0:
                    pss[i][j] = pss[j][i] = (np.sum(train_data_transpose_matrix[i][ind] * train_data_transpose_matrix[j][ind]))/(down1*down2)
                else:
                    pss[i][j] = pss[j][i] = 0
        print(pss[i])
    import csv
    df = pd.DataFrame(pss)
    df.to_csv("item_based_similar.csv",header=True,index=True)
except KeyboardInterrupt:
    tqdm.close()
    raise
t2=time.time()
print(t2-t1)