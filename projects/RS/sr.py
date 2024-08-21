import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
from sklearn.metrics import mean_squared_error
import seaborn as sns
col_names= ['u','m','r','t']
dfData =pd.read_table("C:/Users/chaim/OneDrive/Desktop/IA2I S8/Recherche en IA/TP2/ml-100k/u1.base", names=col_names,delimiter="\t")
dfTest =pd.read_table("C:/Users/chaim/OneDrive/Desktop/IA2I S8/Recherche en IA/TP2/ml-100k/u1.test", names=col_names,delimiter="\t")

 # Visualisation des donnée

# Création de la heatmap des corrélations entre les notes données par les utilisateurs
plt.figure(figsize=(10,10))
sns.heatmap(dfData.corr(), annot=True, cmap="YlGnBu")
plt.show()

# Création de l'histogramme des notes données par les utilisateurs
dfData.hist(bins=50, figsize=(20,15))
plt.show()

# Modèle 1 : Modèle de moyenne globale simple¶
R = np.zeros((943, 1682))
# print(R)
# # Affecter les valeures du dataframe dans la matrice R
for i in range(0, 80000):
    n1 = dfData['u'][i] - 1
    n2 = dfData['m'][i] - 1
    n3 = dfData['r'][i]
    R[n1][n2] = n3

print(R)

Vr = dfTest['r']

average = dfData['r'].mean()
print("average is = ", format(average))
ratings = dfData['r'].values
frequencies = np.bincount(ratings, minlength=5)
print(frequencies)
R1 = np.where(R == 0.0, average, R)

Vp = np.zeros((20000,))
for i in range(20000):
    u = dfTest["u"][i]-1
    m = dfTest["m"][i]-1
    Vp[i] = R1[u][m]


RMSE1 = np.sqrt(mean_squared_error(Vr, Vp))
print("RMSE1 = ", format(RMSE1))

# Modèle 2 : Modèle multivarié à effet de film
bias_movie = np.zeros((1681, 1))
for i in range(1681):
    bias_movie[i] = (R[:, i].sum() / (np.count_nonzero(R[:, i]))) - average
R2 = np.zeros((943, 1681))
for i in range(943):
    for j in range(1681):
        if (R[i][j] == 0):
            R2[i][j] = bias_movie[j] + average
        else:
            R2[i][j] = R[i][j]
print(R2)
Vp2 = np.zeros((20000, 1))
for i in range(20000):
    u = dfTest['u'][i] - 1
    m = dfTest['m'][i] - 1
    Vp2[i] = R2[u][m]
Vp2 = np.nan_to_num(Vp2)
RMSE2 = np.sqrt(mean_squared_error(Vr, Vp2))
print(RMSE2)

# Modèle 3 : Modèle multivarié d'effet film et utilisateur
bias_user = np.zeros((943, 1))
for i in range(943):
    bias_user[i] = (R[i, :].sum() / (np.count_nonzero(R[i, :]))) - average
R3 = np.zeros((943, 1681))
for i in range(943):
    for j in range(1681):
        if (R[i][j] == 0):
            R3[i][j] = bias_user[i] + bias_movie[j] + average
        else:
            R3[i][j] = R[i][j]

Vp3 = np.zeros((20000, 1))
for i in range(20000):
    u = dfTest['u'][i] - 1
    m = dfTest['m'][i] - 1
    Vp3[i] = R3[u][m]
Vp3 = np.nan_to_num(Vp3)
RMSE3 = np.sqrt(mean_squared_error(Vr, Vp3))
print(RMSE3)

# Modèle 4 : Modèle multivarié d'effet film et utilisateur régularisé

for i in range(80000):
    n1 = dfData['u'][i] - 1
    n2 = dfData['m'][i] - 1
    n = dfData['r'][i]
    R[n1][n2] = n

K = 20
lam = 0.1
gamma_u = np.random.normal(0, .1, (943, K))  # user factors
gamma_m = np.random.normal(0, .1, (1682, K))  # movie factors
bi = np.zeros((1682))  # movie bias
bu = np.zeros((943))  # user bias
mu = dfData['r'].mean()  # global mean

for step in range(40):
    for i in range(80000):
        u = dfData['u'][i] - 1
        m = dfData['m'][i] - 1
        r = dfData['r'][i]
        err = r - (mu + bi[m] + bu[u] + np.dot(gamma_u[u], gamma_m[m]))
        bi[m] += 0.005 * (err - lam * bi[m])
        bu[u] += 0.005 * (err - lam * bu[u])
        gamma_u[u] += 0.005 * (err * gamma_m[m] - lam * gamma_u[u])
        gamma_m[m] += 0.005 * (err * gamma_u[u] - lam * gamma_m[m])

Vr = dfTest['r']
Vp4 = np.zeros(20000)

for i in range(20000):
    u = dfTest['u'][i] - 1
    m = dfTest['m'][i] - 1
    Vp4[i] = mu + bi[m] + bu[u] + np.dot(gamma_u[u], gamma_m[m])

RMSE4 = np.sqrt(mean_squared_error(Vr, Vp4))
print('RMSE4 = ', RMSE4)