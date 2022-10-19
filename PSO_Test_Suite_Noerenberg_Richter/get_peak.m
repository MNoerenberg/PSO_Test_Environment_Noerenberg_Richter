function [max_peak] = get_peak(func_num)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
max_peak=[];
switch func_num
    case 1 
        max_peak = [0; 30];
    case 2 
        max_peak = [0.1; 0.3; 0.5; 0.7; 0.9];
    case 3 
        max_peak = [0.08];
    case 4
        max_peak = [3.0,2.0; -2.805118,3.131312; -3.779310,-3.283186; 3.584428,-1.848126];
    case 5
        max_peak = [-0.0898,0.7126; 0.0898,-0.7126];
    case 6
        max_peak = [-7.0835,-7.7083;-7.7083,-7.0835;-1.4251,-7.0835;-0.8003,-7.7083;4.8581,-7.0835;5.4829,-7.7083;-7.7083,5.4829;-7.0835,4.8581;-1.4251,5.4829;-0.8004,4.8581;4.8580,5.4829;5.4829,4.8580;-7.7083,-0.8004;-7.0835,-1.4251;-1.4252,-0.8003;-0.8003,-1.4251;4.8580,-0.8003;5.4829,-1.4251];
    case 7
        max_peak = [0.3330,0.3330;0.3330,0.6242;0.3330,1.1701;0.3330,2.1933;0.3330,4.1112;0.3330,7.7063;0.6242,0.3330;0.6242,0.6242;0.6242,1.1701;0.6242,2.1932;0.6242,4.1112;0.6242,7.7063;1.1701,0.3330;1.1701,0.6242;1.1701,1.1701;1.1701,2.1933;1.1701,4.1112;1.1701,7.7063;2.1932,0.3330;2.1933,0.6242;2.1933,1.1701;2.1932,2.1933;2.1933,4.1112;2.1933,7.7063;4.1112,0.6242;4.1112,1.1701;4.1112,2.1933;4.1112,4.1112;4.1112,7.7063;4.1112,0.3330;7.7063,0.6242;7.7062,1.1701;7.7062,2.1933;7.7062,4.1112;7.7062, 7.7063;7.7063,0.3330];
    %case 8
    %case 9
    %case 10
    case 21
        max_peak = zeros(1,get_dimension(func_num));
    case 22
        max_peak = ones(1,get_dimension(func_num));
    case 23
        max_peak = zeros(1,get_dimension(func_num));
    case 24
        max_peak = zeros(1,get_dimension(func_num));
    case 25
        max_peak = zeros(1,get_dimension(func_num));
    case 26
        max_peak = ones(1,get_dimension(func_num));
    case 27
        max_peak = ones(1,get_dimension(func_num));
    case 28
        max_peak = zeros(1,get_dimension(func_num));
    case 29
        max_peak = zeros(1,get_dimension(func_num));
end
  

end