import numpy as np
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.preprocessing import StandardScaler
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
#读取数据集并作相关处理
penguins=pd.read_csv('penguin.csv')
penguins.dropna(inplace=True)
unique_Island_vals = penguins["Island"].unique().tolist()
for i in range(len(unique_Island_vals)):
    penguins=penguins.replace(unique_Island_vals[i],i)
unique_Sex_vals = penguins["Sex"].unique().tolist()
for i in range(len(unique_Sex_vals)):
    penguins = penguins.replace(unique_Sex_vals[i], i)
unique_Age_vals = penguins["Age"].unique().tolist()
for i in range(len(unique_Age_vals)):
    penguins = penguins.replace(unique_Age_vals[i], i)
#将数据集分为训练集和验证集和测试集
X =penguins[["Island",'Culmen Length (mm)', 'Culmen Depth (mm)', 'Flipper Length (mm)', 'Body Mass (g)',"Age"]]
# X =penguins[["Island",'Culmen Length (mm)', 'Culmen Depth (mm)', 'Flipper Length (mm)', 'Body Mass (g)',"Sex","Age"]]
Y = penguins['Species']

#特征缩放
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X)
# 将数据集划分为训练集和测试集和验证集
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2, random_state=42)
# 创建KNN分类器
knn = KNeighborsClassifier(n_neighbors=5)

# 训练模型
knn.fit(X_train, Y_train)
# 在测试集上评估模型
Y_test_pred = knn.predict(X_test)
test_acc = accuracy_score(Y_test, Y_test_pred)
print("Test Accuracy: {:.3f}".format(test_acc))

    # 交叉调参
param_grid = {
    "n_neighbors": np.arange(1, 21),
    "weights": ["uniform", "distance"],
}
# 进行网格搜索调参
grid_search = GridSearchCV(estimator=knn, param_grid=param_grid, cv=5)
grid_search.fit(X_train, Y_train)

# 输出最佳参数和最佳得分
print("Best parameters found: ", grid_search.best_params_)
print("Best score: ", grid_search.best_score_)

# 使用最佳参数训练模型
knn = KNeighborsClassifier(**grid_search.best_params_)
knn.fit(X_train, Y_train)

# 在测试集上评估模型
Y_test_pred = knn.predict(X_test)
test_acc = accuracy_score(Y_test, Y_test_pred)
print("Test Accuracy: {:.3f}".format(test_acc))
# 可视化混淆矩阵
matrix = confusion_matrix(Y_test, Y_test_pred)
sns.set(font_scale=1.4)
xticklabels = ["AP", "CP", "GP"]
yticklabels = ["AP", "CP", "GP"]
disp = sns.heatmap(matrix, annot=True, cmap=plt.cm.Blues, fmt='g', xticklabels=xticklabels, yticklabels=yticklabels)
disp.set_title('混淆矩阵')
plt.rcParams['font.sans-serif'] = ['SimHei'] # 用来正常显示中文标签
plt.ylabel('实际值')
plt.xlabel('预测值')
plt.show()
# 打印分类报告
report = classification_report(Y_test, Y_test_pred)
print(report)