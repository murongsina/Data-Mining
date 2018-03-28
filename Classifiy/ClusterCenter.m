function [ V ] = ClusterCenter( X, C )
%CLUSTERCENTER 此处显示有关此函数的摘要
% 计算聚类中心
%   此处显示详细说明
% 参数：
%      X    -数据集
%      C    -簇划分
    Vy = unique(C);
    [~, n] = size(X);
    Vx = zeros(k, n);
    for i = 1 : k
        Xi = X(C==Vy(i), :);
        if length(Xi) == 1
            Vx(i, :) = Xi;
        else
            Vx(i, :) = mean(Xi);
        end
    end
    % 构造聚类中心
    V = [Vx, Vy];
end

