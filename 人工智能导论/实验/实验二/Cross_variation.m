function [avg_fitness,next_generation]= Cross_variation(M,generation)
% 交叉
    Pm=0.10;
    next_generation=[];
    for i=1:4*M
        rand1=round((9)*rand(1))+1;
        rand2=round((9)*rand(1))+1;
        father=dec2bin(generation(rand1),8);
        mather=dec2bin(generation(rand2),8);
        rand3=round((6)*rand(1))+1;
        exchange_father1=father(1:rand3);
        exchange_father2=father(rand3+1:8);
        exchange_mather1=mather(1:rand3);
        exchange_mather2=mather(rand3+1:8);
        son_bin1=[exchange_father1,exchange_mather2];
        son_bin2=[exchange_mather1,exchange_father2];
        rand_variation=rand();
%  互换变异
        if rand_variation<Pm
            rand_variation1=round((7)*rand(1))+1;
            rand_variation2=round((7)*rand(1))+1;
            tmp=son_bin1(rand_variation1);
            son_bin1(rand_variation1)=son_bin2(rand_variation2);
            son_bin2(rand_variation2)=tmp;
        end
        son1=bin2dec(son_bin1);
        son2=bin2dec(son_bin2);
        next_generation(2*i-1)=son1;
        next_generation(2*i)=son2;
    end


    next_generation=sort(next_generation);
    len=length(next_generation);
    [fitness_matrix,avg_fitness]=OTSU(len,next_generation);
    fitness_matrix=sortrows(fitness_matrix',2,'descend')';
    %保留部分差的子代
    rand4=round((len/4)*rand(1))+len*3/4-1;
    fitness_matrix(:,rand4-4:len)=[];
    fitness_matrix(:,20:rand4-5)=[];
    next_generation=fitness_matrix(1,:);
end

