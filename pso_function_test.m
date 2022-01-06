clc; clear all;

population = 3;
func = 1;
gen = 10;
c = [1.0, 1.5, 2.0];

runs = 3;
random = 0; % 1 for random | 0 for chaos

[random_matrix, random_init] = get_random(get_dimension(func),population,gen,runs,random);

best_x = ones(get_dimension(func),runs);
gens_best = zeros(get_dimension(func)+1,gen,runs);

for run = [1:1:runs]
    
r_init = random_init(:,:,:,run);    
r_generations = random_matrix(:,:,:,run);


[best_x(:,run), gens_best(:,:,run)] =pso(func, population, gen, c, r_init, r_generations);

end

