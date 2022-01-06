function [random_matrix, random_init] = get_random(dimensions,population,generations,runs,random_source)

random_matrix = zeros(2,population,generations,runs);
random_init = zeros(dimensions,population,2,runs);


if(random_source == 1)
    for k = [1:runs]
        for i = [1:generations]
            for j = [1:population]
                random_matrix(:,j,i,k) = rand(2,1);
            end
        end
        random_init(:,:,:,k) = rand(dimensions,population,2);
    end    
elseif(random_source == 0)
    for k = [1:runs]
        chaos_list = get_chaos(population*generations*2);
        chaos_list_ind = 1;
        init_list = get_chaos(population*dimensions*2);
        init_list_ind = 1;
        for i = [1:generations]
            for j = [1:population]
                random_matrix(:,j,i,k) = [chaos_list(chaos_list_ind),chaos_list(chaos_list_ind+1)];
                chaos_list_ind = chaos_list_ind+2;
                if(i == 1)
                    for l = [1:dimensions]
                        random_init(l,j,:,k) = [init_list(init_list_ind),init_list(init_list_ind+1)];
                        init_list_ind = init_list_ind+2;
                    end
                end
            end
        end      
    end    
end


end %function

