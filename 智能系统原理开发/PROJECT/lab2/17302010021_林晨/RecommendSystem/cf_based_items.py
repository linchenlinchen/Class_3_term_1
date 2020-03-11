import csv
import pandas as pd
import numpy as np
train_data = pd.read_csv('train.csv', sep=',')  # 训练数据
train_data_matrix = np.zeros((2967, 4125))  # 训练数据矩阵
sim_data_matrix = np.zeros((4125, 4125))  # 相似矩阵
for line in train_data.itertuples():
    train_data_matrix[line[1], line[2]] = line[3]
train_data_transpose_matrix = np.transpose(train_data_matrix)
df = pd.read_csv("item_based_similar.csv")
sim_data_matrix = df.values
print(sim_data_matrix.shape)
user_number = train_data_matrix.shape[0]
item_number = train_data_matrix.shape[1]
sim_data_transform_matrix = sim_data_matrix - np.identity(item_number, dtype=float)
result = np.zeros((item_number, user_number))
import time
from tqdm import tqdm
t1 = time.time()
try:
    for i in tqdm(range(item_number)):
        for j in range(user_number):
            if train_data_transpose_matrix[i][j] == 0:
                ind = np.nonzero(sim_data_transform_matrix[i] * train_data_matrix[j])
                abs_sim_sum = np.sum(np.fabs(sim_data_transform_matrix[i][ind]))
                if abs_sim_sum == 0:
                    abs_sim_sum += 0.0000001
                result[i][j] = np.sum(sim_data_transform_matrix[i][ind] * train_data_matrix[j][ind])/abs_sim_sum
                # 修正预测打分结果
                if result[i][j] > 5:
                    result[i][j] = 5
                elif result[i][j] < 0:
                    result[i][j] = 0
            else:
                result[i][j] = train_data_transpose_matrix[i][j]
    import csv
    tran_result = np.transpose(result)
    df = pd.DataFrame(tran_result)
    df.to_csv("item_based_result.csv", header=True, index=True)

    df = pd.read_csv("test_index.csv")
    test_data_matrix = df.values
    predict_matrix = np.zeros((39679, 2))
    for i in range(test_data_matrix.shape[0]):
        predict_matrix[i][0] = i
        predict_matrix[i][1] = tran_result[test_data_matrix[i][0]][test_data_matrix[i][1]]
    # print(predict_matrix)
    df = pd.DataFrame({"dataID": predict_matrix.T[0], "rating": predict_matrix.T[1]})
    df.to_csv("predict_item.csv", index=False)
except KeyboardInterrupt:
    tqdm.close()
    raise
t2 = time.time()
print(t2 - t1)
