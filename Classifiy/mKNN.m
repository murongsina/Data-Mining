function [ idx, dist, M ] = mKNN( X, k )
%MKNN 此处显示有关此函数的摘要
% Mutual K Nearest Neighbours
%   此处显示详细说明
% 参数：
%     X    -数据集
%     k    -近邻数
% 输出：
%   idx    -所有样本k近邻矩阵
%  dist    -所有样本k近邻距离矩阵
%     M    -mutual KNN Graph

    [m, ~] = size(X);
    % 求得相互最近邻
    [idx, dist] = knnsearch(X, X, 'K', k + 1,'Distance','euclidean');
    idx = idx(:, 2:k + 1);
    dist = dist(:, 2:k + 1);
    % 构造mutual KNN Graph
    M = Inf(m, m); % zeros(m, m); % spalloc(m, m, 2*k*m);
    for i = 1 : m
        M(i, idx(i, :)) = dist(i, :);
    end
end