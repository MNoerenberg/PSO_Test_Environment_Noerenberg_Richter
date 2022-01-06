function [cur_pop] = get_chaos(gens)
max_pop = 1;
r = 4;
gens = 1000;

init_pop = rand();
cur_pop = zeros(1,gens);
cur_pop(1) = init_pop;

for gen = [2:1:gens]
    cur_pop(gen) = r*cur_pop(gen-1)*(max_pop-cur_pop(gen-1));
end


% figure
% hold on
% plot(cur_pop);
% grid on
% xlim([0;gens])
% ylim([0;max_pop])

