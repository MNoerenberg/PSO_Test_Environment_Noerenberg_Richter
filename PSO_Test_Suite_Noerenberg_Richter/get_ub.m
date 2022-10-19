% ******************************************************************************
% * Version: 1.0
% * Last modified on: 21 January, 2013 
% * Developers: Michael G. Epitropakis, Xiaodong Li.
% *      email: mge_(AT)_cs_(DOT)_stir_(DOT)_ac_(DOT)_uk 
% *           : xiaodong_(DOT)_li_(AT)_rmit_(DOT)_edu_(DOT)_au 
% * ****************************************************************************

function ub = get_ub(fno)
if (fno == 1 )
	ub = 30;
elseif (fno== 2 || fno== 3)
	ub = 1;
elseif (fno== 4)
	ub = 6*ones(1,2);
elseif (fno== 5)
	ub = [1.9 1.1];
elseif (fno== 6 || fno== 8)
	ub = 10*ones(1,2);
elseif (fno== 7 || fno== 9)
	ub = 10*ones(1,2);
elseif (fno== 10)
	ub = ones(1,2);
elseif (fno== 11 || fno== 12 || fno== 13)
	dim = get_dimension(fno);
	ub = 5*ones(1,dim);
elseif (fno== 14 || fno== 15)
	dim = get_dimension(fno);
	ub = 5*ones(1,dim);
elseif (fno== 16 || fno== 17)
    dim = get_dimension(fno);
    ub = 5*ones(1,dim);
elseif (fno== 18 || fno== 19)
    dim = get_dimension(fno);
    ub = 5*ones(1,dim);
elseif (fno== 20 )
    dim = get_dimension(fno);
    ub = 5*ones(1,dim);
elseif (fno== 21 || fno==24 || fno==25)
    dim= get_dimension(fno);
    ub = 5.12 * ones(1,dim);
elseif (fno== 22 || fno==26 || fno==27)
    dim= get_dimension(fno);
    ub = 5.12 * ones(1,dim);
elseif (fno== 23 || fno==28 || fno==29)
    dim= get_dimension(fno);
    ub = 5.12 * ones(1,dim);
else
    ub = [];
end
