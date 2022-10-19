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
%         scale = [1.9; 1.1];
%         x_scaled = (x.*(2*scale)-scale);
          x1_scaled = (x(1)*3.8)-1.9;
          x2_scaled = (x(2)*2.2)-1.1;
          x_scaled = [x1_scaled; x2_scaled];
    case 6
        x_scaled = (x.*20)-10;
    case 7
        x_scaled = x.*(10-0.25)+0.25;
    case 8
        x_scaled = x;
    case 9
        x_scaled = x;
    case 10
        x_scaled = x;
    case 21
        x_scaled = (x.*10.24) - 5.12;
    case 22
        x_scaled = (x.*10.24) - 5.12;
    case 23
        x_scaled = (x.*10.24) - 5.12;
    case 24
        x_scaled = (x.*10.24) - 5.12;
    case 25
        x_scaled = (x.*10.24) - 5.12;
    case 26
        x_scaled = (x.*10.24) - 5.12;
    case 27
        x_scaled = (x.*10.24) - 5.12;
    case 28
        x_scaled = (x.*10.24) - 5.12;
    case 29
        x_scaled = (x.*10.24) - 5.12;
end
     

end

