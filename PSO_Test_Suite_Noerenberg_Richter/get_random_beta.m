function [random_matrix, random_init] = get_random_beta(dimensions,population,generations,runs,random_source,alpha,beta)



random_matrix = zeros(2,population,generations,runs);
random_init = zeros(dimensions,population,2,runs);


if(random_source == 1)  %beta
    rng shuffle
    for k = [1:runs]
        for i = [1:generations]
            for j = [1:population]
                random_matrix(:,j,i,k) = betarnd(alpha,beta,[2,1]);
            end
        end        
    end
    rng(1);
    random_init(:,:,:,:) = rand(dimensions,population,2,runs);
elseif(random_source == 0)  %chaos
    rng shuffle
    for k = [1:runs]
        chaos_list = get_chaos(population*generations*2);
        chaos_list_ind = 1;
        for i = [1:generations]
            for j = [1:population]
                random_matrix(:,j,i,k) = [chaos_list(chaos_list_ind),chaos_list(chaos_list_ind+1)];
                chaos_list_ind = chaos_list_ind+2;
            end
        end      
    end
    rng(1);
    random_init(:,:,:,:) = rand(dimensions,population,2,runs);
end


end %function

