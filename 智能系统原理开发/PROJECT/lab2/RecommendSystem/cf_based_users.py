import numpy as np
import pandas as pd
#手动删掉sim文件的第一列序号
train_data = pd.read_csv('train.csv', sep=',')  # 训练数据
train_data_matrix = np.zeros((2967, 4125))  # 训练数据矩阵
sim_data_matrix = np.zeros((2967, 2967))  # 相似矩阵
sim_data_transform_matrix = np.zeros((2967, 2967))  # 相似矩阵的转置

for line in train_data.itertuples():
    train_data_matrix[line[1], line[2]] = line[3]
train_data_transpose_matrix = np.transpose(train_data_matrix)
df = pd.read_csv("user_based_similar.csv")
sim_data_matrix = df.values
user_number = train_data_matrix.shape[0]
item_number = train_data_matrix.shape[1]
sim_data_transform_matrix = sim_data_matrix - np.identity(user_number, dtype=float)
result = np.zeros((user_number, item_number))
import time
from tqdm import tqdm

t1 = time.time()
mean_user = np.average(train_data_matrix, 1, weights=np.int64(train_data_matrix > 0))
try:
    for i in tqdm(range(user_number)):
        for j in range(item_number):
            if train_data_matrix[i][j] == 0:
                ind = np.nonzero(sim_data_transform_matrix[i] * train_data_transpose_matrix[j])
                # print(sim_data_matrix[i][ind])
                # print((train_data_transpose_matrix[j][ind]-mean_user[ind]))
                # print(np.sum(sim_data_matrix[i][ind]*(train_data_transpose_matrix[j][ind]-mean_user[ind])))
                # print(np.sum(np.fabs(sim_data_transform_matrix[i][ind])))
                # 分母
                abs_sim_sum = np.sum(np.fabs(sim_data_transform_matrix[i][ind]))
                # 对分母进行微小量添加
                if abs_sim_sum == 0:
                    abs_sim_sum += 0.0000001
                result[i][j] = mean_user[i] + np.sum(sim_data_matrix[i][ind] * (train_data_transpose_matrix[j][ind] - mean_user[ind])) / abs_sim_sum
                # 修正预测打分结果
                if result[i][j] > 5:
                    result[i][j] = 5
                elif result[i][j] < 0:
                    result[i][j] = 0
            else:
                result[i][j] = train_data_matrix[i][j]
        print(result[i])

    import csv
    df = pd.DataFrame(result)
    df.to_csv("user_based_result.csv", header=True, index=True)
except KeyboardInterrupt:
    tqdm.close()
    raise
t2 = time.time()
print(t2 - t1)
