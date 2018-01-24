function [ idx ] = NPPS( X, Y, k )
%NPPS 此处显示有关此函数的摘要
%   X    -数据集
%   Y    -标签集
%   k    -近邻数
%   此处显示详细说明
    % 得到维数
    [m, ~] = size(X);
    % 得到距离
    M = DIST(X);
    % 筛选样本
    samples = zeros(m, 1);
    for x = 1 : m
        % 计算近邻熵、近邻匹配
        [ ~, entropy, match, J ] = NeighborsProperty( X, Y, M, x, k );
        % 选择近邻熵大于0，近邻匹配大于1/J的样本点
        if entropy > 0 && match >= 1/J
            samples(x, :) = 1;
        end
    end
    % 得到被选中样本点的下标
    idx = find(samples == 1);
end

