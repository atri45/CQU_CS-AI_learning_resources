% 层次分析法AHP实现

% 输入准则层数量和方案层数量
n = input("请输入准则层数量：");
m = input("请输入方案层数量：");

% 输入准则层成对比较矩阵并计算权向量
a = input("请输入准则层对目标层的成对比较矩阵："); 
A = calculate_weight_vector(a);

% 输入方案层成对比较矩阵并计算权向量
b = zeros(m,m);
B = zeros(m,n);
for i = 1:n
    b = input("请输入方案层对第" + i + "准则的成对比较矩阵："); 
    B(:,i) = calculate_weight_vector(b);
end

% 计算组合权向量
C = zeros(m,1);
for i = 1:m
    C = B * A;
end
disp("最终组合权向量为：")
disp(C)


% 计算权向量函数
function mout= calculate_weight_vector(min)
    [n,n] = size(min);  

    % 求最大特征根和特征向量,v表特征向量，d表示特征值构成的对角矩阵, max_v表示最大特征根
    [v,d] = eig(min);
    max_v = max(max(d));
    
    % 一致性检验
    % 计算一致性指标CI
    CI = (max_v-n) / (n-1);
    RI = [0 0 0.52 0.89 1.12 1.26 1.36 1.41 1.46 1.49 1.52 1.54 1.56 1.58 1.59];
    % 计算一致性比例CR
    %disp("一致性比例为")
    CR = CI / RI(n);
    %disp(CR)
    
    if CR < 0.1
        %disp("通过一致性检验")
    else
        disp("没有通过一致性检验")
    end
    
    % 计算权向量
    if CR < 0.1 
        % find函数用于寻找最大特征值所在的位置，v(:,max_c)找到最大特征值对应的列
        [max_r,max_c]=find(max_v,1);
        mout = v(:,max_c)/sum(v(:,max_c));
        %disp("权向量为：")
        %disp(mout)
    end

end