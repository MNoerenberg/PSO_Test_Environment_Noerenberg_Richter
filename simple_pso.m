% a simple Implementation of a PSO-Algorithm as described in
% "Improved particle swarm optimization combined with chaos"
% Bo Liu, Ling Wang, Yi-Hui Jin, Fang Tang, De-Xian Huang - November 2004

clear all; clc;

%useful variabes

func_num = 1;                                       %Number of testfunction
dimensions = get_dimension(func_num);               %dimension of testfunction

pop_size = 100;                                     %size of population

pop_x = ones(dimensions,pop_size);                  %Matrix with all Locations
pop_v = ones(dimensions,pop_size);                  %Matrix with all Velocities
first_Ind = pop_x(:,1);                             %Location of first Individual

pop_values = ones(1,pop_size);                      %storage for fitness-values
best_ind = 1;                                       %Index of individual with best occured value
best_x = ones(dimensions,1);                        %Position of best value
pop_x_best = ones(dimensions,pop_size);             %personal best of each individual

%% parameters for variation of pop_v (dynamics of PSO)
% as described in Zelinka "On Chaotic Dynamic Impact on the Heuristic Algorithm Performance"
inertia = 1;
cognitive = 1.5;        %cognitive component enhances exploitation
social = 2.0;           %social component enhances exploration


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
    pop_values(i) = niching_func(pop_x(:,i),func_num);
end

%% find best individual in the population
[best_val, best_ind] = max(pop_values);         %store global best value and Index of corresonding individual
pop_x_best = pop_x;                             %store personal best for each individual
best_x = pop_x_best(:,best_ind);


%put the following into 2 sensible functions for structuring purposes

for i = [1:100]                                                              %insert stopping criterion here as while loop
   [best_val, best_ind] = max(pop_values);                                   %store global best value and Index of corresponding induvidual
   best_x = pop_x_best(:,best_ind);
    for j = [1:pop_size]                            
        if( pop_values(j) > niching_func(pop_x_best(:,j),func_num) )
            pop_x_best(:,j) = pop_x(:,j);
        end
    end
   
    for k = [1:pop_size]            %get new pop_v and pop_x
        pop_v(:,k) = inertia*pop_v(:,k) + cognitive*rand()*(pop_x_best(:,k)-pop_x(:,k)) + social*rand()*(best_x-pop_x(:,k));
        
        sumsq_v = 0;        
        for l = [1:dimensions]      %get absolute_value of pop_v vector
            sumsq_v = sumsq_v + pop_v(l,k)^2;
        end
        abs_v = sqrt(sumsq_v);
        
        if(abs_v > 0.1)             %if absolute is bigger than 0.1 scale pop_v to be 0.1 (saturation)
            pop_v(:,k) = pop_v(:,k)./(10*abs_v);
        end
        pop_x(:,k) = pop_x(:,k) + pop_v(:,k);
    end
    
    
    
    if(pop_x_best(:,best_ind) ~= best_x)
        disp("Fehler")
        break;
    end
end




best_x_overall_scaled = scaling(best_x, func_num)

