function [ M ] = XYDist( X, Y )
%XYDIST 此处显示有关此函数的摘要
%   此处显示详细说明
    [m, ~] = size(X);
    [n, ~] = size(Y);
    M = zeros(m, n);
    for i = 1 : m
        for j = 1 : n
            M(i, j) = norm(X(i, :)-Y(j, :));
        end
    end
end