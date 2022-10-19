function [random_matrix, random_init] = get_random_beta_vs_norm(dimensions,population,generations,runs,random_source,alpha,beta,my,sigma)

% random_source : 0 for beta
%                 1 for normal

random_matrix = zeros(2,population,generations,runs);
random_init = zeros(dimensions,population,2,runs);

switch random_source
    case 0  % Betaverteilung
        rng shuffle
        for k = [1:runs]
            for i = [1:generations]
                for j = [1:population]
                    random_matrix(:,j,i,k) = betarnd(alpha,beta,[2,1]);
                end
            end
        end
        rng(1);
        random_init(:,:,:,:) = rand(dimensions,population,2,runs);
    case 1  % Normalverteilung
        rng shuffle
        for k = [1:runs]
            for i = [1:generations]
                for j = [1:population]
                    random_matrix(:,j,i,k) = abs(normrnd(my,sigma,[2,1]));
                end
            end
            rng(1);
            random_init(:,:,:,:) = rand(dimensions,population,2,runs);
        end        
end

end %function

