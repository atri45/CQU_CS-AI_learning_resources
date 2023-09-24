function next_particle = cross_exploration(now_particle,pline,gline,w,c1,c2)
    next_particle=[];
    parent1=now_particle;

    %轮盘赌
    rand_num=rand(w+c1+c2);
    if rand_num<=w
        parent2=parent1(end:-1:1,:);
    elseif rand_num<=w+c1
        parent2=pline;
    else
        parent2=gline;
    end


%     顺序交叉
    start_rand=round(30*rand(1))+1;
    end_rand=round(30*rand(1))+1;
    if start_rand>end_rand
        t=start_rand;
        start_rand=end_rand;
        end_rand=t;
    end
    line_index(1:start_rand-1)=1:start_rand-1;
    line_index(end_rand+1:31)=end_rand+1:31;
    next_particle(start_rand:end_rand)=parent1(start_rand:end_rand);
    next_harf=parent1(start_rand:end_rand);
    next_particle(end_rand+1:31)=zeros(1,31-end_rand);

    j=1;  %记录到第几个了
    for i=1:length(parent2)
        if((next_particle(i)==0))
            while(j<=31)
                    if(ismember(parent2(j),next_harf))
                        j=j+1;
                    end
                    if(~ismember(parent2(j),next_harf))
                        next_particle(i)=parent2(j);
                        j=j+1;
                        break;
                end
            end
        end
    end

end

