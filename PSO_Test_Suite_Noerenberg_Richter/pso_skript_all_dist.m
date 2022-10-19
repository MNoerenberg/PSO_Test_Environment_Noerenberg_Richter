clc; clear all;

population = 100;
functions = [1 2 3 4 5 6 7 21 22 23 24 25 26 27 28 29];
min_func = 1;
max_func = 16;          % höchste Testfunktion Nummer nicht Name
generations = 200;
c = [0.72, 1.49, 1.49];          % inertia_weight, cognitive_weight, social_weight für PSO
runs = 1000;
no_func = max_func - min_func + 1;

chaos_or_random = zeros(1,no_func);        % Chaos oder Random besser für Parameterraum
fit_chaos_or_random = zeros(1,no_func);    % Chaos oder Random besser für Fitnessraum

mean_dev_chaos = 0.404*ones(1,no_func);
mean_dev_beta0505   = 0.404*ones(1,no_func);
mean_dev_norm0501 = 0.404*ones(1,no_func);
mean_dev_beta25 = 0.404*ones(1,no_func);
mean_dev_beta52 = 0.404*ones(1,no_func);
mean_dev_beta15 = 0.404*ones(1,no_func);
mean_dev_beta51 = 0.404*ones(1,no_func);

mean_dev_fit_chaos = 0.404*ones(1,no_func);
mean_dev_fit_beta0505 = 0.404*ones(1,no_func);
mean_dev_fit_norm0501 = 0.404*ones(1,no_func);
mean_dev_fit_beta25 = 0.404*ones(1,no_func);
mean_dev_fit_beta52 = 0.404*ones(1,no_func);
mean_dev_fit_beta15 = 0.404*ones(1,no_func);
mean_dev_fit_beta51 = 0.404*ones(1,no_func);

all_diversities = 4.04*ones(no_func,runs,8,generations);
all_lyap_exponents = 4.04*ones(no_func,runs,8);

save('200_differences_1000.mat','population','min_func','max_func','generations','c','runs')

for random_source = [0:7]
    disp(num2str(random_source))
    
    for func_index = [min_func:1:max_func]
        curr_func = functions(func_index);
        max_pos=no_func;
        
        index_for_lists = find(functions==curr_func);
        pos_all_diversities = index_for_lists-min_func+1;
        
        dimensions = get_dimension(curr_func);       %dimension of testfunction
        best_x = ones(dimensions,runs);
        gens_best = zeros(dimensions+1,generations,runs);
        
        switch random_source
            case 0  % chaos
                [random_matrix, random_init] = get_random_beta(dimensions,population,generations,runs,0,0.5,0.5);
                 all_lyap_exponents(func_index,:,random_source+1) = get_lyap_from_matrix(random_matrix);
             case 1  % beta0505
                [random_matrix, random_init] = get_random_beta(dimensions,population,generations,runs,1,0.5,0.5);
                 all_lyap_exponents(func_index,:,random_source+1) = get_lyap_from_matrix(random_matrix);
             case 2  % norm0501
                [random_matrix, random_init] = get_random_beta_vs_norm(dimensions,population,generations,runs,1,0.5,0.5,0.5,0.1);
                 all_lyap_exponents(func_index,:,random_source+1) = get_lyap_from_matrix(random_matrix);
             case 3  % beta25
                [random_matrix, random_init] = get_random_beta(dimensions,population,generations,runs,1,2,5);  
                 all_lyap_exponents(func_index,:,random_source+1) = get_lyap_from_matrix(random_matrix);
             case 4  % beta52
                [random_matrix, random_init] = get_random_beta(dimensions,population,generations,runs,1,5,2);
                 all_lyap_exponents(func_index,:,random_source+1) = get_lyap_from_matrix(random_matrix);
             case 5  % beta15
                [random_matrix, random_init] = get_random_beta(dimensions,population,generations,runs,1,1,5);
                 all_lyap_exponents(func_index,:,random_source+1) = get_lyap_from_matrix(random_matrix);
             case 6  % beta51
                [random_matrix, random_init] = get_random_beta(dimensions,population,generations,runs,1,5,1);
                 all_lyap_exponents(func_index,:,random_source+1) = get_lyap_from_matrix(random_matrix);
             case 7  % beta0505_2
                [random_matrix, random_init] = get_random_beta(dimensions,population,generations,runs,1,0.5,0.5);
                 all_lyap_exponents(func_index,:,random_source+1) = get_lyap_from_matrix(random_matrix);
        end


        for run = [1:1:runs]

            r_init = random_init(:,:,:,run);
            r_generations = random_matrix(:,:,:,run);

            [best_x(:,run), gens_best(:,:,run), all_diversities(pos_all_diversities,run,random_source+1,:)] = pso(curr_func, population, generations, c, r_init, r_generations, run, random_source);    %eigentlicher PSO
        end

        %% Auswertung der Abstände
        switch curr_func
            case 1
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_1 = best_x;
                max_peak_1 = get_peak(1);
                
                if(random_source == 0)
                    diff_para_1 = 0.404*ones(8,runs);
                    diff_fit_1 = 0.404*ones(8,runs);
                end
                
                best_fit_1 = 200;
                
                for run = [1:1:runs]
                    list_of_distances = ones(1,length(max_peak_1));
                    diff_fit_1(random_source+1,run) = abs(best_fit_1-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length(max_peak_1)]                                         %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_1(i,:)'-best_func_1(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_1(random_source+1,run) = min(list_of_distances);                 %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_1(1,:));
                mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_1(2,:));
                mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_1(3,:));
                mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_1(4,:));
                mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_1(5,:));
                mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_1(6,:));
                mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_1(7,:));
                
                mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_1(1,:));
                mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_1(2,:));
                mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_1(3,:));
                mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_1(4,:));
                mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_1(5,:));
                mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_1(6,:));
                mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_1(7,:));
                save('200_differences_1000.mat','diff_para_1','diff_fit_1','-append');
                
            case 2
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_2 = best_x;
                max_peak_2 = get_peak(2);
                
                if(random_source == 0)
                    diff_para_2 = 0.404*ones(8,runs);
                    diff_fit_2 = 0.404*ones(8,runs);
                end
                best_fit_2 = 1;
                
                for run = [1:1:runs]
                    list_of_distances = 4.04*ones(1,length(max_peak_2));
                    diff_fit_2(random_source+1,run) = abs(best_fit_2-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length(max_peak_2)]                                         %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_2(i,:)'-best_func_2(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_2(random_source+1,run) = min(list_of_distances);                 %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_2(1,:));
                mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_2(2,:));
                mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_2(3,:));
                mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_2(4,:));
                mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_2(5,:));
                mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_2(6,:));
                mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_2(7,:));
                
                mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_2(1,:));
                mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_2(2,:));
                mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_2(3,:));
                mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_2(4,:));
                mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_2(5,:));
                mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_2(6,:));
                mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_2(7,:));
                save('200_differences_1000.mat','diff_para_2','diff_fit_2','-append');
                
            case 3
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_3 = best_x;
                max_peak_3 = get_peak(3);
                
                if(random_source == 0)
                    diff_para_3 = 0.404*ones(8,runs);
                    diff_fit_3 = 0.404*ones(8,runs);
                end
                
                best_fit_3 = 1;
                
                for run = [1:1:runs]
                    list_of_distances = 4.04*ones(1,length(max_peak_3));
                    diff_fit_3(random_source+1,run) = abs(best_fit_3-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length(max_peak_3)]                                         %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_3(i,:)'-best_func_3(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_3(random_source+1,run) = min(list_of_distances);                 %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_3(1,:));
                mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_3(2,:));
                mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_3(3,:));
                mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_3(4,:));
                mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_3(5,:));
                mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_3(6,:));
                mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_3(7,:));
                
                mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_3(1,:));
                mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_3(2,:));
                mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_3(3,:));
                mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_3(4,:));
                mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_3(5,:));
                mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_3(6,:));
                mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_3(7,:));
                save('200_differences_1000.mat','diff_para_3','diff_fit_3','-append');
                
            case 4
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_4 = best_x;
                max_peak_4 = get_peak(4);
                
                if(random_source == 0)
                    diff_para_4 = 0.404*ones(8,runs);
                    diff_fit_4 = 0.404*ones(8,runs);
                end
                
                best_fit_4 = 200;
                
                for run = [1:1:runs]
                    list_of_distances = ones(1,length(max_peak_4));
                    diff_fit_4(random_source+1,run) = abs(best_fit_4-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length(max_peak_4)]                                         %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_4(i,:)'-best_func_4(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_4(random_source+1,run) = min(list_of_distances);                 %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_4(1,:));
                mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_4(2,:));
                mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_4(3,:));
                mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_4(4,:));
                mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_4(5,:));
                mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_4(6,:));
                mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_4(7,:));
                
                mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_4(1,:));
                mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_4(2,:));
                mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_4(3,:));
                mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_4(4,:));
                mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_4(5,:));
                mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_4(6,:));
                mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_4(7,:));
                save('200_differences_1000.mat','diff_para_4','diff_fit_4','-append');
                
            case 5
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_5 = best_x;
                max_peak_5 = get_peak(5);
                
                if(random_source == 0)
                    diff_para_5 = 0.404*ones(8,runs);
                    diff_fit_5 = 0.404*ones(8,runs);
                end
                
                best_fit_5 =  1.0316;
                
                for run = [1:1:runs]
                    list_of_distances = ones(1,length(max_peak_5));
                    diff_fit_5(random_source+1,run) = abs(best_fit_5-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length(max_peak_5)]                                         %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_5(i,:)'-best_func_5(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_5(random_source+1,run) = min(list_of_distances);                 %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_5(1,:));
                mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_5(2,:));
                mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_5(3,:));
                mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_5(4,:));
                mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_5(5,:));
                mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_5(6,:));
                mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_5(7,:));
                
                mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_5(1,:));
                mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_5(2,:));
                mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_5(3,:));
                mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_5(4,:));
                mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_5(5,:));
                mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_5(6,:));
                mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_5(7,:));
                save('200_differences_1000.mat','diff_para_5','diff_fit_5','-append');
                
            case 6
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_6 = best_x;
                max_peak_6 = get_peak(6);
                
                if(random_source == 0)
                    diff_para_6 = 0.404*ones(8,runs);
                    diff_fit_6 = 0.404*ones(8,runs);
                end
                
                best_fit_6 = 186.7309;
                
                for run = [1:1:runs]
                    list_of_distances = ones(1,length(max_peak_6));
                    diff_fit_6(random_source+1,run) = abs(best_fit_6-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length(max_peak_6)]                                         %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_6(i,:)'-best_func_6(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_6(random_source+1,run) = min(list_of_distances);                %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_6(1,:));
                mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_6(2,:));
                mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_6(3,:));
                mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_6(4,:));
                mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_6(5,:));
                mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_6(6,:));
                mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_6(7,:));
                
                mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_6(1,:));
                mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_6(2,:));
                mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_6(3,:));
                mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_6(4,:));
                mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_6(5,:));
                mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_6(6,:));
                mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_6(7,:));
                save('200_differences_1000.mat','diff_para_6','diff_fit_6','-append');
                
            case 7
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_7 = best_x;
                max_peak_7 = get_peak(7);
                
                if(random_source == 0)
                    diff_para_7 = 0.404*ones(8,runs);
                    diff_fit_7 = 0.404*ones(8,runs);
                end
                
                best_fit_7 = 2;
                
                for run = [1:1:runs]
                    list_of_distances = ones(1,length(max_peak_7));
                    diff_fit_7(random_source+1,run) = abs(best_fit_7-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length(max_peak_7)]                                         %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_7(i,:)'-best_func_7(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_7(random_source+1,run) = min(list_of_distances);                 %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                    mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_7(1,:));
                    mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_7(2,:));
                    mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_7(3,:));
                    mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_7(4,:));
                    mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_7(5,:));
                    mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_7(6,:));
                    mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_7(7,:));
                    
                    mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_7(1,:));
                    mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_7(2,:));
                    mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_7(3,:));
                    mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_7(4,:));
                    mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_7(5,:));
                    mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_7(6,:));
                    mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_7(7,:));
                    save('200_differences_1000.mat','diff_para_7','diff_fit_7','-append');
                    
                
            case 8
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_8 = best_x;
                max_peak_8 = get_peak(1);
                
                if(random_source == 0)
                    diff_para_8 = 0.404*ones(8,runs);
                    diff_fit_8 = 0.404*ones(8,runs);
                end
                
                best_fit_8 = niching_func(max_peak_8(1,:),8);
                
                for run = [1:1:runs]
                    list_of_distances = ones(1,length(max_peak_8));
                    diff_fit_8(random_source+1,run) = abs(best_fit_8-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length(max_peak_8)]                                         %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_8(i,:)'-best_func_8(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_8(random_source+1,run) = min(list_of_distances);                 %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_8(1,:));
                mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_8(2,:));
                mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_8(3,:));
                mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_8(4,:));
                mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_8(5,:));
                mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_8(6,:));
                mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_8(7,:));
                
                mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_8(1,:));
                mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_8(2,:));
                mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_8(3,:));
                mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_8(4,:));
                mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_8(5,:));
                mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_8(6,:));
                mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_8(7,:));
                save('200_differences_1000.mat','diff_para_8','diff_fit_8','-append');
                
                
            case 9
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_9 = best_x;
                max_peak_9 = get_peak(1);
                
                if(random_source == 0)
                    diff_para_9 = 0.404*ones(8,runs);
                    diff_fit_9 = 0.404*ones(8,runs);
                end
                
                best_fit_9 = niching_func(max_peak_9(1,:),9);
                
                for run = [1:1:runs]
                    list_of_distances = ones(1,length(max_peak_9));
                    diff_fit_9(random_source+1,run) = abs(best_fit_9-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length(max_peak_9)]                                         %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_9(i,:)'-best_func_9(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_9(random_source+1,run) = min(list_of_distances);                 %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_9(1,:));
                mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_9(2,:));
                mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_9(3,:));
                mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_9(4,:));
                mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_9(5,:));
                mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_9(6,:));
                mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_9(7,:));
                
                mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_9(1,:));
                mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_9(2,:));
                mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_9(3,:));
                mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_9(4,:));
                mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_9(5,:));
                mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_9(6,:));
                mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_9(7,:));
                save('200_differences_1000.mat','diff_para_9','diff_fit_9','-append');
                    
                
            case 10
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_10 = best_x;
                max_peak_10 = get_peak(10);
                
                if(random_source == 0)
                    diff_para_10 = 0.404*ones(8,runs);
                    diff_fit_10 = 0.404*ones(8,runs);
                end
                
                best_fit_10 = niching_func(max_peak_10(1,:),10);
                
                for run = [1:1:runs]
                    list_of_distances = ones(1,length(max_peak_10));
                    diff_fit_10(random_source+1,run) = abs(best_fit_10-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length(max_peak_10)]                                          %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_10(i,:)'-best_func_10(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_10(random_source+1,run) = min(list_of_distances);            %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_10(1,:));
                mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_10(2,:));
                mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_10(3,:));
                mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_10(4,:));
                mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_10(5,:));
                mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_10(6,:));
                mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_10(7,:));
                
                mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_10(1,:));
                mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_10(2,:));
                mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_10(3,:));
                mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_10(4,:));
                mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_10(5,:));
                mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_10(6,:));
                mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_10(7,:));
                save('200_differences_1000.mat','diff_para_10','diff_fit_10','-append');
                    
               
            case 21
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_21 = best_x;
                max_peak_21 = get_peak(21);
                [length_21, width_21] = size(max_peak_21);
                
                if(random_source == 0)
                    diff_para_21 = 0.404*ones(8,runs);
                    diff_fit_21 = 0.404*ones(8,runs);
                end
                
                best_fit_21 = niching_func(max_peak_21(1,:),21);
                
                for run = [1:1:runs]
                    list_of_distances = ones(1,length_21);
                    diff_fit_21(random_source+1,run) = abs(best_fit_21-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length_21]                                          %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_21(i,:)'-best_func_21(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_21(random_source+1,run) = min(list_of_distances);            %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_21(1,:));
                mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_21(2,:));
                mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_21(3,:));
                mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_21(4,:));
                mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_21(5,:));
                mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_21(6,:));
                mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_21(7,:));
                
                mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_21(1,:));
                mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_21(2,:));
                mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_21(3,:));
                mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_21(4,:));
                mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_21(5,:));
                mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_21(6,:));
                mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_21(7,:));
                save('200_differences_1000.mat','diff_para_21','diff_fit_21','-append');
               
            case 22
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_22 = best_x;
                max_peak_22 = get_peak(22);
                [length_22, width_22] = size(max_peak_22);
                
                if(random_source == 0)
                    diff_para_22 = 0.404*ones(8,runs);
                    diff_fit_22 = 0.404*ones(8,runs);
                end
                
                best_fit_22 = niching_func(max_peak_22(1,:),22);
                
                for run = [1:1:runs]
                    list_of_distances = ones(1,length_22);
                    diff_fit_22(random_source+1,run) = abs(best_fit_22-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length_22]                                          %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_22(i,:)'-best_func_22(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_22(random_source+1,run) = min(list_of_distances);            %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_22(1,:));
                mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_22(2,:));
                mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_22(3,:));
                mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_22(4,:));
                mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_22(5,:));
                mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_22(6,:));
                mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_22(7,:));
                
                mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_22(1,:));
                mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_22(2,:));
                mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_22(3,:));
                mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_22(4,:));
                mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_22(5,:));
                mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_22(6,:));
                mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_22(7,:));
                save('200_differences_1000.mat','diff_para_22','diff_fit_22','-append');
                    
            case 23
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_23 = best_x;
                max_peak_23 = get_peak(23);
                [length_23, width_23] = size(max_peak_23);
                
                if(random_source == 0)
                    diff_para_23 = 0.404*ones(8,runs);
                    diff_fit_23 = 0.404*ones(8,runs);
                end
                
                best_fit_23 = niching_func(max_peak_23(1,:),23);
                
                for run = [1:1:runs]
                    list_of_distances = ones(1,length_23);
                    diff_fit_23(random_source+1,run) = abs(best_fit_23-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length_23]                                          %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_23(i,:)'-best_func_23(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_23(random_source+1,run) = min(list_of_distances);            %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_23(1,:));
                mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_23(2,:));
                mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_23(3,:));
                mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_23(4,:));
                mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_23(5,:));
                mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_23(6,:));
                mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_23(7,:));
                
                mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_23(1,:));
                mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_23(2,:));
                mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_23(3,:));
                mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_23(4,:));
                mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_23(5,:));
                mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_23(6,:));
                mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_23(7,:));
                save('200_differences_1000.mat','diff_para_23','diff_fit_23','-append');
                
                case 24
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_24 = best_x;
                max_peak_24 = get_peak(24);
                [length_24, width_24] = size(max_peak_24);
                
                if(random_source == 0)
                    diff_para_24 = 0.404*ones(8,runs);
                    diff_fit_24 = 0.404*ones(8,runs);
                end
                
                best_fit_24 = niching_func(max_peak_24(1,:),21);
                
                for run = [1:1:runs]
                    list_of_distances = ones(1,length_24);
                    diff_fit_24(random_source+1,run) = abs(best_fit_24-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length_24]                                          %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_24(i,:)'-best_func_24(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_24(random_source+1,run) = min(list_of_distances);            %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_24(1,:));
                mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_24(2,:));
                mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_24(3,:));
                mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_24(4,:));
                mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_24(5,:));
                mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_24(6,:));
                mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_24(7,:));
                
                mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_24(1,:));
                mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_24(2,:));
                mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_24(3,:));
                mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_24(4,:));
                mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_24(5,:));
                mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_24(6,:));
                mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_24(7,:));
                save('200_differences_1000.mat','diff_para_24','diff_fit_24','-append');
                
            case 25
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_25 = best_x;
                max_peak_25 = get_peak(25);
                [length_25, width_25] = size(max_peak_25);
                
                if(random_source == 0)
                    diff_para_25 = 0.404*ones(8,runs);
                    diff_fit_25 = 0.404*ones(8,runs);
                end
                
                best_fit_25 = niching_func(max_peak_25(1,:),21);
                
                for run = [1:1:runs]
                    list_of_distances = ones(1,length_25);
                    diff_fit_25(random_source+1,run) = abs(best_fit_25-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length_25]                                          %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_25(i,:)'-best_func_25(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_25(random_source+1,run) = min(list_of_distances);            %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_25(1,:));
                mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_25(2,:));
                mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_25(3,:));
                mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_25(4,:));
                mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_25(5,:));
                mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_25(6,:));
                mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_25(7,:));
                
                mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_25(1,:));
                mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_25(2,:));
                mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_25(3,:));
                mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_25(4,:));
                mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_25(5,:));
                mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_25(6,:));
                mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_25(7,:));
                save('200_differences_1000.mat','diff_para_25','diff_fit_25','-append');
                
             case 26
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_26 = best_x;
                max_peak_26 = get_peak(26);
                [length_26, width_26] = size(max_peak_26);
                
                if(random_source == 0)
                    diff_para_26 = 0.404*ones(8,runs);
                    diff_fit_26 = 0.404*ones(8,runs);
                end
                
                best_fit_26 = niching_func(max_peak_26(1,:),22);
                
                for run = [1:1:runs]
                    list_of_distances = ones(1,length_26);
                    diff_fit_26(random_source+1,run) = abs(best_fit_26-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length_26]                                          %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_26(i,:)'-best_func_26(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_26(random_source+1,run) = min(list_of_distances);            %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_26(1,:));
                mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_26(2,:));
                mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_26(3,:));
                mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_26(4,:));
                mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_26(5,:));
                mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_26(6,:));
                mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_26(7,:));
                
                mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_26(1,:));
                mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_26(2,:));
                mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_26(3,:));
                mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_26(4,:));
                mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_26(5,:));
                mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_26(6,:));
                mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_26(7,:));
                save('200_differences_1000.mat','diff_para_26','diff_fit_26','-append');
            
            case 27
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_27 = best_x;
                max_peak_27 = get_peak(27);
                [length_27, width_27] = size(max_peak_27);
                
                if(random_source == 0)
                    diff_para_27 = 0.404*ones(8,runs);
                    diff_fit_27 = 0.404*ones(8,runs);
                end
                
                best_fit_27 = niching_func(max_peak_27(1,:),22);
                
                for run = [1:1:runs]
                    list_of_distances = ones(1,length_27);
                    diff_fit_27(random_source+1,run) = abs(best_fit_27-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length_27]                                          %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_27(i,:)'-best_func_27(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_27(random_source+1,run) = min(list_of_distances);            %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_27(1,:));
                mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_27(2,:));
                mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_27(3,:));
                mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_27(4,:));
                mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_27(5,:));
                mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_27(6,:));
                mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_27(7,:));
                
                mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_27(1,:));
                mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_27(2,:));
                mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_27(3,:));
                mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_27(4,:));
                mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_27(5,:));
                mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_27(6,:));
                mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_27(7,:));
                save('200_differences_1000.mat','diff_para_27','diff_fit_27','-append');
                
            case 28
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_28 = best_x;
                max_peak_28 = get_peak(28);
                [length_28, width_28] = size(max_peak_28);
                
                if(random_source == 0)
                    diff_para_28 = 0.404*ones(8,runs);
                    diff_fit_28 = 0.404*ones(8,runs);
                end
                
                best_fit_28 = niching_func(max_peak_28(1,:),23);
                
                for run = [1:1:runs]
                    list_of_distances = ones(1,length_28);
                    diff_fit_28(random_source+1,run) = abs(best_fit_28-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length_28]                                          %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_28(i,:)'-best_func_28(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_28(random_source+1,run) = min(list_of_distances);            %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_28(1,:));
                mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_28(2,:));
                mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_28(3,:));
                mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_28(4,:));
                mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_28(5,:));
                mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_28(6,:));
                mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_28(7,:));
                
                mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_28(1,:));
                mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_28(2,:));
                mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_28(3,:));
                mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_28(4,:));
                mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_28(5,:));
                mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_28(6,:));
                mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_28(7,:));
                save('200_differences_1000.mat','diff_para_28','diff_fit_28','-append');
                
             case 29
                index = find(functions==curr_func);
                pos_in_mean_dev = index-min_func+1;
                best_func_29 = best_x;
                max_peak_29 = get_peak(29);
                [length_29, width_29] = size(max_peak_29);
                
                if(random_source == 0)
                    diff_para_29 = 0.404*ones(8,runs);
                    diff_fit_29 = 0.404*ones(8,runs);
                end
                
                best_fit_29 = niching_func(max_peak_29(1,:),23);
                
                for run = [1:1:runs]
                    list_of_distances = ones(1,length_29);
                    diff_fit_29(random_source+1,run) = abs(best_fit_29-max(gens_best(end,:,run))); %Abstand zu besten Fitness
                    
                    for i = [1:1:length_29]                                          %Abstand zu den vorhandenen Maxima als Parameterabstand
                        vek_best2peak = max_peak_29(i,:)'-best_func_29(:,run);
                        list_of_distances(i) = norm(vek_best2peak,2);
                    end
                    diff_para_29(random_source+1,run) = min(list_of_distances);            %Abstand zum nächstgelegenen Maximum als Parameterabstand
                end
                mean_dev_beta0505(pos_in_mean_dev) = mean(diff_para_29(1,:));
                mean_dev_chaos(pos_in_mean_dev) = mean(diff_para_29(2,:));
                mean_dev_norm0501(pos_in_mean_dev) = mean(diff_para_29(3,:));
                mean_dev_beta25(pos_in_mean_dev) = mean(diff_para_29(4,:));
                mean_dev_beta52(pos_in_mean_dev) = mean(diff_para_29(5,:));
                mean_dev_beta15(pos_in_mean_dev) = mean(diff_para_29(6,:));
                mean_dev_beta51(pos_in_mean_dev) = mean(diff_para_29(7,:));
                
                mean_dev_fit_beta0505(pos_in_mean_dev) = mean(diff_fit_29(1,:));
                mean_dev_fit_chaos(pos_in_mean_dev) = mean(diff_fit_29(2,:));
                mean_dev_fit_norm0501(pos_in_mean_dev) = mean(diff_fit_29(3,:));
                mean_dev_fit_beta25(pos_in_mean_dev) = mean(diff_fit_29(4,:));
                mean_dev_fit_beta52(pos_in_mean_dev) = mean(diff_fit_29(5,:));
                mean_dev_fit_beta15(pos_in_mean_dev) = mean(diff_fit_29(6,:));
                mean_dev_fit_beta51(pos_in_mean_dev) = mean(diff_fit_29(7,:));
                save('200_differences_1000.mat','diff_para_29','diff_fit_29','-append');
        end %switch
    end %for test_functions
    
    
    
end

save('200_diversities_1000.mat','all_diversities')
save('200_lyapunov_1000.mat','all_lyap_exponents')

