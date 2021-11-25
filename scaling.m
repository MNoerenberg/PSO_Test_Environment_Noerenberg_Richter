function x_scaled = scaling(x, func_num)

switch func_num
    case 1 
        x_scaled = x*30;
    case 2
        x_scaled = x;
    case 3
        x_scaled = x;
    case 4
        x_scaled = (x.*12) - 6;
    case 5
        scale = [1.9; 1.1];
        x_scaled = (x.*(2*scale)-scale);
    case 6
        x_scaled = x.*10;
    case 7
        x_scaled = 404;
    case 8
        x_scaled = 404;
    case 9
        x_scaled = 404;
    case 10
        x_scaled = 404;    
end
     

end

