function [ X, Y ] = Star( n, m, r )
%STAR 此处显示有关此函数的摘要
% 构造多个簇
%   此处显示详细说明
% 参数：
%    n    -每个簇的样本个数
%    m    -簇数
%    r    -簇半径

    % 构造m个聚类中心
    X = rand(m, 2);
    Y = (1 : m).';
    % 放大2r * 2r
    X = X * [2*r 0;0 2*r];
    X = repmat(X, n, 1) + normrnd(0, 0.24, m*n, 2); %wgn(m * n, 2, 5);
    Y = repmat(Y, n, 1);
end