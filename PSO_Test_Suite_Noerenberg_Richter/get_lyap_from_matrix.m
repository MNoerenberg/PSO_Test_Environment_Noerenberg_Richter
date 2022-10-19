function [lyap_Exponents] = get_lyap_from_matrix(random_matrix)

size_r_matrix = size(random_matrix);
runs = size_r_matrix(4);

lyap_Exponents = 0.404*ones(1,runs);

for run = [1:1:runs]
    sequence = reshape(random_matrix(:,:,:,run),1,[]);
    lyap_Exponents(run) = lyapunovExponent(sequence(1:500),1);
end

end

