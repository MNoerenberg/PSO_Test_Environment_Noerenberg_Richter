% ******************************************************************************
% * Version: 1.0
% * Last modified on: 4 April, 2016 
% * Developers: Michael G. Epitropakis, Xiaodong Li.
% *      email: mge_(AT)_cs_(DOT)_stir_(DOT)_ac_(DOT)_uk 
% *           : xiaodong_(DOT)_li_(AT)_rmit_(DOT)_edu_(DOT)_au 
% * ****************************************************************************

function [fit] = get_dimension(nfunc)
Dims = [1 1 1 2 2 2 2 3 3 2 2 2 2 3 3 5 5 10 10 20]; % dimensionality of benchmark functions
switch nfunc
    case 21
        fit = 10;
    case 22
        fit = 20;
    case 23
        fit = 30;
    case 24 % Rastrigin 20
        fit = 20;
    case 25 % Rastrigin 30
        fit = 30;
    case 26 % Rosenbrock 10
        fit = 10;
    case 27 % Rosenbrock 30
        fit = 30;
    case 28 % Sphere 10
        fit = 10;
    case 29 % Sphere 20
        fit = 20;
    otherwise
        fit = Dims(nfunc);     
end
