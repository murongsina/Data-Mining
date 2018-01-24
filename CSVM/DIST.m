function [ matrix ] = DIST( X )
%DIST 此处显示有关此函数的摘要
%   计算距离矩阵
%   此处显示详细说明
%   X        -输入数据集
%   matrix   -相似度矩阵
    % 初始化距离矩阵，已访问表，最小生成树
    [m,~] = size(X);
    matrix = zeros(m,m);
    % 计算点之间的距离
    for i = 1 : m
        for j = i + 1 : m
            d = norm(X(i,:)-X(j,:));
            matrix(i,j) = d;
            matrix(j,i) = d;
        end
    end
end

