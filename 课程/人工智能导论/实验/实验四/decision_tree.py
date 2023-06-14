import pandas as pd
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report
import matplotlib.pyplot as plt
import seaborn as sns
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
X_train,X_test,Y_train,Y_test=train_test_split(X,Y,test_size=0.2,random_state=42)
#模型训练
model = DecisionTreeClassifier(random_state=42)
model.fit(X_train, Y_train)
#网络搜索10折交叉调参的过程
param_grid = {'criterion': ['gini', 'entropy'],
              'max_depth': [3,4,5,6,7],
              'min_samples_split': [2,3,5,7,10],
              'min_samples_leaf': [1,2,3],
              'max_features': ['sqrt', 'log2', None]}
grid_search = GridSearchCV(estimator=model, param_grid=param_grid, cv=10)
grid_search.fit(X_train, Y_train)
print("Best parameters found:", grid_search.best_params_)
print("Best score:", grid_search.best_score_)
model = DecisionTreeClassifier(**grid_search.best_params_,random_state=42)
model.fit(X_train, Y_train)

#在测试集上评估模型
Y_test_pred = model.predict(X_test)
test_acc = accuracy_score(Y_test, Y_test_pred)
print(f"Test Accuracy: {test_acc:.3f}")
# 打印分类报告
report = classification_report(Y_test, Y_test_pred)
print(report)
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

