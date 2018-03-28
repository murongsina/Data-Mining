function [ D ] = Sine( n )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
    data = rand(n, 2)*[4*pi 0;0 4];
    data(:,2) = data(:,2) - 2;
    label = sign(data(:,2) - sin(data(:,1)));
    D = [data, label];
end

