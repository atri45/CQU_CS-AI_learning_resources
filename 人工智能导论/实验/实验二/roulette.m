function fitness_matrix= roulette(M,fitness_matrix)
    %轮盘赌选择子代种群
    fitness_matrix=sortrows(fitness_matrix',2,'descend')';
    fitness_total=sum(fitness_matrix(2,:),2);
    temp=0;
    for i=1:M
        fitness_matrix(3,i)=fitness_matrix(2,i)/fitness_total;
        temp=temp+fitness_matrix(3,i);
        fitness_matrix(4,i)=temp;
    end
    for i=1:M-1
        rand_=rand(1);
        if rand_>=0 && rand_<fitness_matrix(4,1)
            fitness_matrix(5,1)=fitness_matrix(5,1)+1;
        elseif rand_>=fitness_matrix(4,1)&&rand_<fitness_matrix(4,2)
            fitness_matrix(5,2)=fitness_matrix(5,2)+1;
        elseif rand_>=fitness_matrix(4,2)&&rand_<fitness_matrix(4,3)
            fitness_matrix(5,3)=fitness_matrix(5,3)+1;
        elseif rand_>=fitness_matrix(4,3)&&rand_<fitness_matrix(4,4)
            fitness_matrix(5,4)=fitness_matrix(5,4)+1;
        elseif rand_>=fitness_matrix(4,4)&&rand_<fitness_matrix(4,5)
            fitness_matrix(5,5)=fitness_matrix(5,5)+1;
        elseif rand_>=fitness_matrix(4,5)&&rand_<fitness_matrix(4,6)
            fitness_matrix(5,6)=fitness_matrix(5,6)+1;
        elseif rand_>=fitness_matrix(4,6)&&rand_<fitness_matrix(4,7)
            fitness_matrix(5,7)=fitness_matrix(5,7)+1;
        elseif rand_>=fitness_matrix(4,7)&&rand_<fitness_matrix(4,8)
            fitness_matrix(5,8)=fitness_matrix(5,8)+1;
        elseif rand_>=fitness_matrix(4,8)&&rand_<fitness_matrix(4,9)
            fitness_matrix(5,9)=fitness_matrix(5,9)+1;
        elseif rand_>=fitness_matrix(4,9)&&rand_<fitness_matrix(4,10)
            fitness_matrix(5,10)=fitness_matrix(5,10)+1;
        elseif rand_>=fitness_matrix(4,10)&&rand_<fitness_matrix(4,11)
            fitness_matrix(5,11)=fitness_matrix(5,11)+1;
        elseif rand_>=fitness_matrix(4,11)&&rand_<fitness_matrix(4,12)
            fitness_matrix(5,12)=fitness_matrix(5,12)+1;
        elseif rand_>=fitness_matrix(4,12)&&rand_<fitness_matrix(4,13)
            fitness_matrix(5,13)=fitness_matrix(5,13)+1;
        elseif rand_>=fitness_matrix(4,13)&&rand_<fitness_matrix(4,14)
            fitness_matrix(5,14)=fitness_matrix(5,14)+1;
        elseif rand_>=fitness_matrix(4,14)&&rand_<fitness_matrix(4,15)
            fitness_matrix(5,15)=fitness_matrix(5,15)+1;
        elseif rand_>=fitness_matrix(4,15)&&rand_<fitness_matrix(4,16)
            fitness_matrix(5,16)=fitness_matrix(5,16)+1;
        elseif rand_>=fitness_matrix(4,16)&&rand_<fitness_matrix(4,17)
            fitness_matrix(5,17)=fitness_matrix(5,17)+1;
        elseif rand_>=fitness_matrix(4,17)&&rand_<fitness_matrix(4,18)
            fitness_matrix(5,18)=fitness_matrix(5,18)+1;
        elseif rand_>=fitness_matrix(4,18)&&rand_<fitness_matrix(4,19)
            fitness_matrix(5,19)=fitness_matrix(5,19)+1;
        else
            fitness_matrix(5,20)=fitness_matrix(5,20)+1;
        end
    end
%     保留部分差的
    rand_1=round((15)*rand(1))+5;
    fitness_matrix(5,rand_1)=fitness_matrix(5,rand_1)+1;
    rand_2=round((15)*rand(1))+5;
    fitness_matrix(5,rand_2)=fitness_matrix(5,rand_2)+1;
end

