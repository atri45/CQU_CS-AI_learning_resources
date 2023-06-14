function greedy_line = greedy_initialize(dis_matrix)
%     先用TSP构造初始路径
    dis_matrix1(2:32,2:32)=dis_matrix(2:32,2:32);
    dis_matrix1(1:32,1)=1001:1032;
    dis_matrix1(1,1:32)=1001:1032;
    greedy_line=[];
    for i=1:length(dis_matrix1)
        for j=1:length(dis_matrix1)
            if i==j
                dis_matrix1(i,j)=9999;
            end
        end
    end
    now_city=round((30)*rand(1))+2;
    greedy_line(1)=now_city;
    for i=1:30
        [x,next_city]=min(dis_matrix1(now_city,:));
        greedy_line(i+1)=next_city;
        dis_matrix1(:,now_city)=9999;
        dis_matrix1(:,next_city)=9999;
        now_city=next_city;
    end
   
         
end

