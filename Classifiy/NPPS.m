function [ Xr, Yr, W ] = NPPS( X, Y, k )
%NPPS 此处显示有关此函数的摘要
% Neighbors Property Pattern Selection
%   此处显示详细说明
% 参数：
%   X    -数据集
%   Y    -标签集
%   k    -近邻数

    % 得到维数
    [m, ~] = size(X);
    % 得到距离
    M = DIST(X);
    % 筛选样本
    samples = zeros(m, 1);
    W = zeros(m, 1);
    for i = 1 : m
        % 计算近邻熵、近邻匹配
        [ ~, entropy, match, J ] = NP( Y, M, i, k );
        % 选择近邻熵大于0，近邻匹配大于1/J的样本点
        if (entropy > 0) && (match >= 1/J)
            samples(i, :) = 1;
        else
            samples(i, :) = 0;
        end
        W(i) = entropy*match; % 近邻熵*近邻匹配作为样本的权重
    end
    % 得到被选中样本点的下标
    idx = find(samples == 1);
    Xr = X(idx, :); Yr = Y(idx, :);
end