function [ idx, entropy, match, J ] = NeighborsProperty( X, Y, M, x, k )
%UNTITLED 此处显示有关此函数的摘要
%   X    -数据集
%   M    -距离矩阵
%   x    -样本x
%   k    -近邻数
%   此处显示详细说明
    % 统计类别数
    class = unique(Y);
    J = length(class);
    % 求得x的k近邻
    [~, idx] = sort(M(x,:), 'ascend');
    idx = idx(:,2:1+k);
    % 计算x的近邻熵
    entropy = 0;
    for i = 1 : J
        % 统计x的k近邻中i类个数
        x_j = find(Y(idx)==class(i));
        p_i = length(x_j)/k;
        entropy = entropy + p_i*log2(1/p_i);
    end
    % 计算x的近邻匹配
    x_j = find(Y(idx)==Y(x));
    match = length(x_j)/k;
end