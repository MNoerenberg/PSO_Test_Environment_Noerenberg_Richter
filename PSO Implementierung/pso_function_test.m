clc; clear all;

population = 100;
func = 1;
gen = 100;
c = [1.0, 1.5, 2.0];

[best_x, gens_best] =pso(func, population, gen, c);

