%OTSU计算适应度并通过轮盘赌得到子代
function [g,avg_fitness]=OTSU(M,new_species)
        g=zeros(5,M);
    for i=1:M
        grayscale_matrix=imread('testPic3.jpg');
        grayscale_matrix = rgb2gray(grayscale_matrix);
        num_former=0;
        num_after=0;
        gray_total_former=0;
        gray_total_after=0;
        Grayscale=new_species(1,i);
        [row,col]=size(grayscale_matrix);
        for j=1:row
            for k=1:col
                if(grayscale_matrix(j,k)<Grayscale)
                    gray_total_former=gray_total_former+int32(grayscale_matrix(j,k));
                    grayscale_matrix(j,k)=0;
                    num_former=num_former+1;
                else
                    gray_total_after=gray_total_after+int32(grayscale_matrix(j,k));
                    grayscale_matrix(j,k)=255;
                    num_after=num_after+1;
                end
            end
        end
            w0=num_former/(1772*1181);
            w1=num_after/(1772*1181);
            u0=gray_total_former/num_former;
            u1=gray_total_after/num_after;
            g(1,i)= Grayscale;
            g(2,i)=w0*w1*(u0-u1)^(2);
            avg_fitness=sum(g(2,:))/(M);
    end

end

