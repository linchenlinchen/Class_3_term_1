import numpy as np
import pandas as pd
df = pd.read_csv("user_based_result.csv")
result_data_matrix = df.values
df = pd.read_csv("test_index.csv")
test_data_matrix = df.values

predict_matrix = np.zeros((39679,2))
for i in range(test_data_matrix.shape[0]):
    predict_matrix[i][0] = i
    predict_matrix[i][1] = result_data_matrix[test_data_matrix[i][0]][test_data_matrix[i][1]]
print(predict_matrix)
df = pd.DataFrame(predict_matrix)
df.to_csv("predict.csv")

