function [  ] = Scatter( D, sz, cp, cn)
%SCATTER 此处显示有关此函数的摘要
% 绘制散点图
%   此处显示详细说明
% 参数：
%    D   -数据集
%    sz  -大小
%    cp  -正类点样式
%    cn  -负类点样式

    % 分割样本和标签
    [X, Y] = SplitDataLabel(D);
    % 分割正负类点
    Xp = X(Y==1, :); Xn = X(Y==-1, :);
    % 绘制正类点
    scatter(Xp(:, 1), Xp(:, 2), sz, cp);
    hold on
    % 绘制负类点
    scatter(Xn(:, 1), Xn(:, 2), sz, cn);
    hold on;
end