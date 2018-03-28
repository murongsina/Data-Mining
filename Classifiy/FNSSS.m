function [ Xn, Yn ] = FNSSS( X, Y, r, k )
%FNSSS 此处显示有关此函数的摘要
% Fixed Neighborhood Sphere Sample Selection (FNSSS)
%   此处显示详细说明
% 参数：
%   X    -样本
%   Y    -标签
%   r    -近邻球半径
%   k    -子样本数

    [m, n] = size(X);
    % 按照r将每一维的区间划分成网格
    mins = min(X);
    maxs = max(X);
    ranges = ceil((maxs - mins)/r);
    % 对每一个样本进行分区
    blocks = ceil((X - mins)/r);
    % 筛选样本
    samples = zeros(m, 1);
    % 从n个维度筛选邻近block样本集得到cells集合
    cells = cell(n, 1);
    for i = 1 : m
        % 得到样本i所在block
        b = blocks(i, :);
        for j = 1 : n
            index = b(j);
            if index == 1
                % 在j维处于左边缘
                cells{j} = find(blocks(:, j)==1 | blocks(:, j)==2);
            elseif b(j) == ranges(j)
                % 在j维处于右边缘
                cells{j} = find(blocks(:, j)==index | blocks(:, j)==(index-1));
            else
                % 在j维的中间区域
                cells{j} = find(blocks(:, j)==(index-1) | blocks(:, j)==index | blocks(:, j)==(index+1));
            end
        end
        % 得到筛选并集
        for j = 2 : n
            cells{1} = intersect(cells{1}, cells{j});
        end
        % 筛选邻近的同类点
        Ys = find(Y==Y(i));
        idx = intersect(Ys, cells{1});
        % step 2: count the neighbors in the neighborhood sphere;
        vecs = X(idx, :)-X(i, :);
        dists = sqrt(sum(vecs.*vecs, 2));
        samples(i, :) = length(find(dists<=r/3));
    end
    % step 3: sort the samples according to the number of the neighbors by ascending order;
    [~, IX] = sort(samples, 'ascend');
    % step 4: reserving the l samples to represent the training set.
    Xn = X(IX(1:k), :); Yn = Y(IX(1:k), :);
end