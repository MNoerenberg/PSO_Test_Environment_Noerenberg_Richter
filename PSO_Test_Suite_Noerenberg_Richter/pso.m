% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
% * implementation of a PSO-algorithm
% * ARGUMENTS in the order:
% * - function-Nr. you want to evaluate (as provided by CEC 2017 test suite)
% * - size of used population (Number of particles is searchspace)
% * - # of generations (iterations)
% * - vector with parameters [inertia, cognitive_component, social_component]
% * - random_init -> matrix of size dimensionsX2 for initialisation of
% *   pop_x and pop_v
% * - random_generations -> matrix of size 2Xpop_sizeXgenerations containing
% * - randomvalues for weighting cognitive and social component in each
% *   generations
% *
% * RETURNS
% * - best position in search-space (non-normed, scaled)
% * - best position and fitness for each generation as Matrix [position+fitness X generation]
% *
% * date: November 2021
% * author: Paul Moritz Nörenberg
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


function [best_x_overall_scaled, best_per_gen, diversities] = pso(func_num, pop_size, generations, c, random_init, random_generations, run, rand_source)

%useful variabes
switch func_num
    case 21
        dimensions = 10;
    case 22
        dimensions = 20;
    case 23
        dimensions = 30;
    otherwise
        dimensions = get_dimension(func_num);       %dimension of testfunction    
end        

pop_x = ones(dimensions,pop_size);                  %Matrix with all Locations
pop_v = ones(dimensions,pop_size);                  %Matrix with all Velocities

pop_fitness = ones(1,pop_size);                      %storage for fitness-values

global_best_x = ones(dimensions,1);                 %Position of best value
pop_best_x = ones(dimensions,pop_size);             %personal best of each individual

best_per_gen = -1*ones(dimensions+1,generations);   %store prepared for best occuring x and fitness

best_x_overall_scaled = ones(dimensions,1);

rand = random_generations;  %shorten the name
avg_v = ones(1,generations);
sum_avg_v = 0;

diversities = 404*ones(1,generations);

%% initialize Population Location
for i = [1:pop_size]
    pop_x(:,i) = random_init(:,i,1);
end

%% initialize Population Velocities
for i = [1:pop_size]
    pop_v(:,i) = random_init(:,i,2)*2-1; %random Numbers in [-1 -> 1]
end

%% first evaluation of testfuncion
for i = [1:pop_size]
    pop_fitness(i) = real(niching_func(pop_x(:,i),func_num));
end

%% find best individual in the population
[global_best_fit, global_best_ind] = max(pop_fitness);        %store global best fitness and Index of corresonding individual
pop_best_x = pop_x;                                    %store personal best for each individual
global_best_x = pop_best_x(:,global_best_ind);
  
           
%%
for i = [1:generations]                                                              %insert stopping criterion here as while loop

    % get swarm diversity
    diversities(i) = get_diversity(pop_x);

    for k = [1:pop_size]
        
        % get new pop_v
        pop_v(:,k) = c(1)*pop_v(:,k) + c(2)*rand(1,k,i)*(pop_best_x(:,k)-pop_x(:,k)) + c(2)*rand(2,k,i)*(global_best_x-pop_x(:,k));
        abs_v = norm(pop_v(:,k),2); % 2 norm of the velocity vektor
        
        % if absolute is bigger than 0.1 scale pop_v to be 0.1 (saturation)
        if(abs_v > 0.1)
            pop_v(:,k) = pop_v(:,k)./(10*abs_v);
        end
        
        % get new pop_x
        pop_x(:,k) = pop_x(:,k) + pop_v(:,k);  
        
        % Check if new Positions are still in search room
        
        for dim = [1:1:dimensions]
            if(pop_x(dim,k) < 0)
                pop_x(dim,k) = 0;
            elseif (pop_x(dim,k) > 1)
                pop_x(dim,k) = 1;
            end              
        end
        
        %update fitness
        pop_fitness(k) = real(niching_func(pop_x(:,k),func_num));    
    end
    
    %calculate average movement of population
    sum_avg_v = 0;
    for p = [1:1:pop_size]
        sum_avg_v = sum_avg_v + norm(pop_v(:,p),2);
    end
    avg_v(i) = sum_avg_v / pop_size;
    
    
    [curr_best_fit, curr_best_ind] = max(pop_fitness);                         %store global best value and Index of corresponding induvidual
    
    for individual = [1:pop_size]
        if (pop_fitness(individual) > niching_func(pop_best_x(:,individual),func_num))
            pop_best_x(:,individual) = pop_x(:,individual);
        end
    end
    
    if (curr_best_fit > global_best_fit)
        global_best_x = pop_x(:,curr_best_ind);
    end
    
    best_per_gen(1:end-1,i) = scaling(pop_x(:,curr_best_ind),func_num);
    best_per_gen(end,i) = curr_best_fit;
    
end

best_x_overall_scaled = scaling(global_best_x, func_num);
end

