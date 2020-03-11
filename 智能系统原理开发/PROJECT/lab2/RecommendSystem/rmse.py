import numpy as np
def get_rmse(G_o, G_train):
    add = 0
    row = G_o.shape[0]
    col = G_o.shape[1]
    a = row * col
    for i in range(row):
        for j in range(col):
            add += np.square(G_o[i][j] - G_train[i][j])
    return np.sqrt(add / a)