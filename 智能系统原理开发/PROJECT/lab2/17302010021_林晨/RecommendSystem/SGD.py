import numpy as np
import pandas as pd
from random import sample

from PMF import get_dict_u, get_random_dict, get_train_or_test_mat, train_data_matrix


def update_F(old_F, old_G, alpha, lbd, train_data_mat, u, m):
    old_F_T = np.transpose(old_F)
    (old_F_T)[u] = ((1- alpha * lbd) * ((old_F.T)[u]).T - alpha * ((old_G.T[m]).T) * (train_data_mat[u][m] - ((old_F.T)[u]) * (old_G.T[m].T))).T
    old_F = old_F_T.T
    return old_F


def update_G(old_F, old_G, alpha, lbd, train_data_mat, u, m):
    old_G_T = np.transpose(old_G)
    (old_G_T)[m] = ((1 - alpha * lbd) * old_G.T[m].T - alpha * (old_F.T[u]).T * (train_data_mat[u][m] - ((old_F.T)[u]) * (old_G.T[m].T))).T
    old_G = old_G_T.T
    return old_G
if __name__ == "__main__":
    F = np.array([[1,2,3],[4,2,3]])
    G = np.array([[3,3,1,4], [2,2,2,3]])
    t = np.array([[1,5,3,3.4], [3,3,1,3], [2,2,2,3]])
    for i in range(3):
        for j in range(4):
            F = update_F(F, G, 1,2, t, i, j)
            print(F)
            G = update_G(F, G, 1,2, t, i, j)
            print(G)