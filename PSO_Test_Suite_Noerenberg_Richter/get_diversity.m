function [dist_cent_avg] = get_diversity(swarm)
% given a swarm returns the average distance of the particles to the swarm
% center
[dim, swarm_size] = size(swarm);
inner_sum = 0;
outer_sum = 0;
x_avg = mean(swarm,2);

for i = [1:1:swarm_size]
    outer_sum = outer_sum + sqrt(inner_sum);
    inner_sum = 0;
    for k = [1:1:dim]
        inner_sum = inner_sum + (swarm(k,i) - x_avg(k))^2;
    end
end

dist_cent_avg = (1/swarm_size) * outer_sum;

end

