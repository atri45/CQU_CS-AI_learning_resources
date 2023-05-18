from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report
from sklearn.preprocessing import LabelEncoder
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler

#读取数据集并作相关处理
penguins=pd.read_csv('penguin.csv')
penguins.dropna(inplace=True)
le = LabelEncoder()  # 将字符串标签转换为数字
penguins['Sex'] = le.fit_transform(penguins['Sex'])
penguins['Species'] = le.fit_transform(penguins['Species'])
penguins['Island'] = le.fit_transform(penguins['Island'])
#将数据集分为训练集和验证集和测试集
X =penguins[["Island",'Culmen Length (mm)', 'Culmen Depth (mm)', 'Flipper Length (mm)', 'Body Mass (g)',"Age"]]
# X =penguins[["Island",'Culmen Length (mm)', 'Culmen Depth (mm)', 'Flipper Length (mm)', 'Body Mass (g)',"Sex","Age"]]
Y = penguins['Species']

# 将数据集划分为训练集和测试集和验证集
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2, random_state=42)
#特征缩放
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# 设置参数网格
param_grid = {'C': [0.1, 1, 10], 'kernel': ['linear', 'poly', 'rbf', 'sigmoid'], 'degree': [2, 3, 4]}

# 定义SVC模型
svc = SVC()

# 进行网格搜索调参
grid_search = GridSearchCV(estimator=svc, param_grid=param_grid, cv=5)
grid_search.fit(X_train, Y_train)

# 输出最佳参数和最佳得分
print("Best parameters found: ", grid_search.best_params_)
print("Best score: ", grid_search.best_score_)

# 使用最佳参数训练模型
svc = SVC(**grid_search.best_params_)
svc.fit(X_train, Y_train)

# 在测试集上评估模型
Y_test_pred = svc.predict(X_test)
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