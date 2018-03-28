function [ D ] = Grid( n, u, v, r )
%GRID 此处显示有关此函数的摘要
%   此处显示详细说明
    data = rand(n, 2)*[u 0;0 v];
    xs = mod(ceil(data(:,1)/r),2)==0;
    ys = mod(ceil(data(:,2)/r),2)==0;
    label = sign(xor(xs, ys) - 0.5);
    D = [data, label];
end

