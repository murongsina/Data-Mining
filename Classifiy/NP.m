function [ idx, entropy, match, J ] = NP( Y, M, x, k )
%NeighborsProperty 此处显示有关此函数的摘要
% 近邻属性
%   此处显示详细说明
%   Y    -标签集
%   M    -距离矩阵
%   x    -样本x
%   k    -近邻数

    % 统计类别数
    class = unique(Y);
    J = length(class);
    % 求得x的k近邻
    idx = KNN(M, x, k);
    % 计算x的近邻熵
    entropy = 0;
    for j = 1 : J
        % 统计x的k近邻中i类个数
        x_j = find(Y(idx)==class(j));
        k_j = length(x_j);
        p_j = k_j/k;
        % 防止概率计算出错
        if p_j > 0
            entropy = entropy - p_j*log2(p_j);
        end
    end
    % 计算x的近邻匹配
    x_j = find(Y(idx)==Y(x));
    match = length(x_j)/k;
end