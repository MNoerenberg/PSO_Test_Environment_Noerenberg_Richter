% a simple Implementation of a PSO-Algorithm as described in
% "Improved particle swarm optimization combined with chaos"
% Bo Liu, Ling Wang, Yi-Hui Jin, Fang Tang, De-Xian Huang - November 2004


% Bestes jeder Generation abspeichern, gesamtes file als Function

clear all; clc;

%useful variabes

func_num = 1;                                       %Number of testfunction
dimensions = get_dimension(func_num);               %dimension of testfunction

pop_size = 100;                                     %size of population
generations = 100;                                  %amount of generations to be iterated

pop_x = ones(dimensions,pop_size);                  %Matrix with all Locations
pop_v = ones(dimensions,pop_size);                  %Matrix with all Velocities

pop_fitness = ones(1,pop_size);                      %storage for fitness-values
global_best_ind = 1;                                 %Index of individual with best occured value

global_best_x = ones(dimensions,1);                 %Position of best value
pop_best_x = ones(dimensions,pop_size);             %personal best of each individual

best_per_gen = -1*ones(dimensions+1,generations);   %store prepared for best occuring x and fitness 

%% parameters for variation of pop_v (dynamics of PSO)
% as described in Zelinka "On Chaotic Dynamic Impact on the Heuristic Algorithm Performance"
c = [1, 1.5, 2.0];

%% initialize Population Location
for i = [1:pop_size]
    pop_x(:,i) = rand(dimensions, 1);
end

%% initialize Population Velocities
for i = [1:pop_size]
    pop_v(:,i) = rand(dimensions, 1)*2-1; %random Numbers in [-1 -> 1]
end

%% first evaluation of testfuncion
for i = [1:pop_size]
    pop_fitness(i) = niching_func(pop_x(:,i),func_num);
end

%% find best individual in the population
[global_best_fit, global_best_ind] = max(pop_fitness);        %store global best fitness and Index of corresonding individual
pop_best_x = pop_x;                                    %store personal best for each individual
global_best_x = pop_best_x(:,global_best_ind);

%%
for i = [1:generations]                                                              %insert stopping criterion here as while loop
    for k = [1:pop_size]
        
        % get new pop_v
        pop_v(:,k) = c(1)*pop_v(:,k) + c(2)*rand()*(pop_best_x(:,k)-pop_x(:,k)) + c(2)*rand()*(global_best_x-pop_x(:,k));
        abs_v = norm(pop_v(:,k),2); % 2 norm of the velocity vektor
        
        % if absolute is bigger than 0.1 scale pop_v to be 0.1 (saturation)
        if(abs_v > 0.1)
            pop_v(:,k) = pop_v(:,k)./(10*abs_v);
        end
        
        % get new pop_x
        pop_x(:,k) = pop_x(:,k) + pop_v(:,k);
        
        %update fitness
        pop_fitness(k) = niching_func(pop_x(:,k),func_num);   
        
    end
    
    
    [curr_best_fit, curr_best_ind] = max(pop_fitness);                         %store global best value and Index of corresponding induvidual
    
    for individual = [1:pop_size]
        if (pop_fitness(individual) > niching_func(pop_best_x(:,individual),func_num))
            pop_best_x(:,individual) = pop_x(:,individual);
        end
    end
    
    if (curr_best_fit > global_best_fit)
        global_best_x = pop_x(:,curr_best_ind);
    end
    
    best_per_gen(1:end-1,i) = pop_x(:,curr_best_ind);
    best_per_gen(end,i) = curr_best_fit;
end


best_x_overall_scaled = scaling(global_best_x, func_num);


