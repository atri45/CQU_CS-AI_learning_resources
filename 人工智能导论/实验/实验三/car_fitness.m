%     添加约束分配车辆
function [lines,fitness] = car_fitness(greedy_line,dis_matrix,demand,M,D,C0,C1)
 line_car=[]; %每辆车服务对象
    lines=zeros(1);     %所有车服务对象
    distance=0;
    distance_sum=0;
    demand_car=0;    %某车的需求量
    tmp_num=1;        %记录贪心路径进入到多少了
    tmp_num1=1;       %记录每辆车的客户个数
    car_num=0;        %记录车的数量
    line_car(1)=1;
    while tmp_num<=length(greedy_line)
        if (length(line_car)==1)    %当还没加服务对象
            distance=distance+dis_matrix(1,greedy_line(tmp_num));
            demand_car=demand_car+demand(greedy_line(tmp_num));
            line_car(tmp_num1+1)=greedy_line(tmp_num);
            tmp_num=tmp_num+1;
            tmp_num1=tmp_num1+1;

        else                       %有的话则加入条件约束判断
            if(((distance+dis_matrix(line_car(length(line_car)),greedy_line(tmp_num))+dis_matrix(greedy_line(tmp_num),1))<=D)&&((demand_car+demand(greedy_line(tmp_num)))<=M))
               distance=distance+dis_matrix(greedy_line(tmp_num-1),greedy_line(tmp_num));
               demand_car=demand_car+demand(greedy_line(tmp_num));
               line_car(tmp_num1+1)=greedy_line(tmp_num);
               tmp_num=tmp_num+1;
               tmp_num1=tmp_num1+1;

            else
               distance=distance+dis_matrix(line_car(length(line_car)),1);
               line_car(tmp_num1+1)=1;
               car_num=car_num+1;
               lines(car_num,1:length(line_car))=line_car;
               distance_sum=distance_sum+distance;
               distance=0;
               demand_car=0;
               line_car=[1];
               tmp_num1=1;
            end
        end
    end
% 最后一辆车特殊处理
    distance=distance+dis_matrix(line_car(length(line_car)),1);
    line_car(tmp_num1+1)=1;
    distance_sum=distance_sum+distance;
    lines(car_num+1,1:length(line_car))=line_car;
    car_num=car_num+1;
    fitness=C1*distance_sum+C0*car_num;
        

end

