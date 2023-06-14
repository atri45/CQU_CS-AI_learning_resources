% 构建距离矩阵
function dis_martix = all_distance(customer)
    dis_martix=zeros(32);
    for i=1:32
        for j=1:32
            dis=sqrt((customer(i,1)-customer(j,1))^2+(customer(i,2)-customer(j,2))^2);
            dis_martix(i,j)=dis;
        end
    end
end

