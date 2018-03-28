function [ C, V ] = KMeans( X, k )
%KMEANS 此处显示有关此函数的摘要
% K均值聚类
%   此处显示详细说明
% 参数：
%    X   -数据集
%    k   -分类数
%    Y   -聚类标签
%    V   -聚类中心
% 输出：
%    C   -簇划分
%    V   -聚类中心

    % 得到数据集维度
    [m, ~] = size(X);
    % 从X中随机选取k个样本作为初始均值向量
    vid = randperm(m, k);
    vx = X(vid, :);
    vy = (1:1:k)';
    % 对于每一个样本
    C = zeros(m, 1);
    % repeat
    iter = 2000;
    updated = 1;
    while updated == 1
        if iter == 0
            break;
        end
        for i = 1 : m
            % 计算xi与各均值向量vi的距离
            dv = repmat(X(i, :), k, 1) - vx;
            di = sum(dv.*dv, 2);
            % 根据距离最近的均值向量确定xj的簇标记
            [~, yi] = min(di);
            % 将样本xj划入相应的簇
            C(i) = yi;
        end
        updated = 0;
        for j = 1 : k
            % 计算新均值向量
            uid = find(C==j);
            un = length(uid);
            ux = sum(X(uid, :), 1)/un;
            % 如果ux!=vx，更新均值向量
            if ux ~= vx(j, :)
                vx(j, :) = ux;
                % 标记均值向量有更新
                updated = 1;
            end
        end
        iter = iter - 1;
    end
    V = [vx, vy];
end