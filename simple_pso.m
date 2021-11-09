% a simple Implementation of a PSO-Algorithm as described in
% "Improved particle swarm optimization combined with chaos"
% Bo Liu, Ling Wang, Yi-Hui Jin, Fang Tang, De-Xian Huang - November 2004

clear all; clc;

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

%% constants for variation of pop_v
% as described in Zelinka "On Chaotic Dynamic Impact on the Heuristic Algorithm Performance"
inertia = 1;
cognitive = 1.5;        %cognitive component enhances exploitation
social = 2.0;           %social component enhances exploration


%% initialize Population Location
for i = [1:pop_size]
    pop_x(:,i) = rand(size(first_Ind),'like',first_Ind);
end

%% initialize Population Velocities
for i = [1:pop_size]
    pop_v(:,i) = rand(size(first_Ind),'like',first_Ind)*2-1; %random Numbers in [-1 -> 1]
end

%% first evaluation of testfuncion
for i = [1:pop_size]
    pop_values(i) = niching_func(pop_x(:,i),func_num);
end

%% find best individual in the population
[best_val, best_ind] = min(pop_values);         %store global best value and Index of corresonding individual
pop_x_best = pop_x;                             %store personal best for each individual
best_x = pop_x_best(:,best_ind);



for i = [1:1000]                                                              %insert stopping criterion here as while loop
   [best_val, best_ind] = min(pop_values);                                   %store global best value and Index of corresponding induvidual
   best_x = pop_x_best(:,best_ind);
    for j = [1:pop_size]                            
        if( pop_values(j) < niching_func(pop_x_best(:,j),func_num) )
            pop_x_best(:,j) = pop_x(:,j);
        end
    end
   
    for k = [1:pop_size]            %get new pop_v and pop_x
        pop_v(:,k) = inertia*pop_v(:,k) + cognitive*rand()*(pop_x_best(:,k)-pop_x(:,k)) + social*rand()*(best_x-pop_x(:,k));   %WIE WIRD MAXIMALGESCHWINDIGKEIT begrenzt
        pop_x(:,k) = pop_x(:,k) + pop_v(:,k);       %SCIHERSTELLEN, DASS X [0 -> 1] ist
    end
    
    if(pop_x_best(:,best_ind) ~= best_x)
        disp("Fehler")
        break;
    end
end
