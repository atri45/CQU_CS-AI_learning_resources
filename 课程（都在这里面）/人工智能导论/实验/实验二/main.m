
M=20;
initialized_species=zeros(1,M);
for i=1:M
    initialized_species(1,i)=round((255)*rand(1));
end
% 选择适合交配的第一代
fitness_matrix=OTSU(M,initialized_species);
fitness_matrix=roulette(M,fitness_matrix);
first_generation=[];
for i=1:M
    if fitness_matrix(5,i)~=0
        for j=1:fitness_matrix(5,i)
            first_generation=[first_generation,fitness_matrix(1,i)];
        end
    end
end
[avg_fitness,next_generation]=Cross_variation(M,first_generation)
tmp_fitness=avg_fitness
for i=1:100
    fprintf("第%d次迭代",i)
    [avg_fitness,next_generation]=Cross_variation(M,next_generation)
    if (abs(tmp_fitness-avg_fitness)<3)
        break;
    end
    tmp_fitness=avg_fitness;
end
figure
I=imread('testPic3.jpg');
subplot(2,2,2)
imshow(I)
I = rgb2gray(I);
subplot(2,2,1)
h = histogram(I);
T=next_generation(1)
[row,col]=size(I);
for j=1:row
        for k=1:col
            if(I(j,k)<T)
                I(j,k)=0;
            else
                I(j,k)=255;
            end
        end
end
subplot(2,2,4)
imshow(I)