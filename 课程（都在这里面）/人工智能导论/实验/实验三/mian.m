
demand=[0,16,11,6,10,7,12,16,6,16,8,14,7,16,3,22,18,19,1,14,8,12,4,8,24,24,2,10,15,2,14,9];
customer = [50, 50; 96, 24; 40, 5; 49, 8; 13, 7; 29, 89; 48, 30; 84, 39; 14, 47; 2, 24; 3, 82;
                65, 10; 98, 52; 84, 25; 41, 69; 1, 65; 51, 71; 75, 83; 29, 32; 83, 3; 50, 93;80, 94;
                5, 42; 62, 70; 31, 62; 19, 97; 91, 75; 27, 49; 23, 15; 20, 70; 85, 60;98, 85;];
dis_matrix = all_distance(customer);
M=120;%最大载重
D=250;%最大距离
C0=30;%启动成本
C1=1;%单位距离成本
w = 0.2;%惯性因子
c1 = 0.4;%自我认知因子
c2 = 0.4;%社会认知因子
initialized_particle=zeros(30,31);
fitness__initial_all=[];

for i=1:30
    greedy_line= greedy_initialize(dis_matrix);
    [lines,fitness] = car_fitness(greedy_line,dis_matrix,demand,M,D,C0,C1);
    fitness__initial_all(i)=fitness;
    initialized_particle(i,:)=greedy_line;
end
[fitness_min,index_min]=min(fitness__initial_all);
gline=initialized_particle(index_min,:);
pline=initialized_particle(index_min,:);
[lines_best,fitness_best]= car_fitness(gline,dis_matrix,demand,M,D,C0,C1);
[lines_part,fitness_part]= car_fitness(gline,dis_matrix,demand,M,D,C0,C1);
iter_max=1000;
iter=0;

while(iter<=500)
    fitness_list=[];
    next_particle=zeros(30,31);
%     交叉
    for i=1:30
        line_now=initialized_particle(i,:);
        next_line = cross_exploration(line_now,pline,gline,w,c1,c2);
        [next_cars,next_fitness] = car_fitness(next_line,dis_matrix,demand,M,D,C0,C1);
        fitness_list(i)=next_fitness;
        next_particle(i,:)=next_line;
    end
    initialized_particle=next_particle;
    [fitness_min_now,index_min]=min(fitness_list);
    line_now_min=next_particle(index_min,:);
    [lines_now,fitness_min_now]= car_fitness(line_now_min,dis_matrix,demand,M,D,C0,C1);
    pline=line_now_min;
    
    if fitness_min_now<fitness_best
        fitness_best=fitness_min_now;
        lines_best=lines_now;
        gline=line_now_min;
    end
    sprintf("迭代次数为：%d   此时的适应度为：%d",iter,fitness_min_now)
    iter=iter+1;
end
lines_best
car1=lines_best(1,:);
car2=lines_best(2,:);
car3=lines_best(3,:);
car4=lines_best(4,:);
car1_x=[];
car1_y=[];
for i=1:length(car1)
    if car1(i)~=0
        car1_x(i)=customer(car1(i),1);
        car1_y(i)=customer(car1(i),2);
    end
end
car2_x=[];
car2_y=[];
for i=1:length(car2)
    if car2(i)~=0
        car2_x(i)=customer(car2(i),1);
        car2_y(i)=customer(car2(i),2);
    end
end
car3_x=[];
car3_y=[];
for i=1:length(car3)
    if car3(i)~=0
        car3_x(i)=customer(car3(i),1);
        car3_y(i)=customer(car3(i),2);
    end
end
car4_x=[];
car4_y=[];
for i=1:length(car4)
    
    if car4(i)~=0        
        car4_x(i)=customer(car4(i),1);
        car4_y(i)=customer(car4(i),2);
    end
end
plot(car1_x,car1_y)
hold on
plot(car2_x,car2_y)
plot(car3_x,car3_y)
plot(car4_x,car4_y)

