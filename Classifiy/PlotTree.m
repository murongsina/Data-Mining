function [  ] = PlotTree( X, Tree, Rho )
%PLOTTREE 此处显示有关此函数的摘要
% 绘制树
%   此处显示详细说明
% 参数：
%      X    -数据集
%   Tree    -树

    [m ,~] = size(X);
    [rho, ~] = mapminmax(Rho.', 0, 1);
    for i = 1 : m
        % 起始点编号
        u = i;
        v = Tree(i);
        % 起始点坐标
        a = [X(u, 1) X(v, 1)];
        b = [X(u, 2) X(v, 2)];
        % 绘制连线
%         plot(a, b, '-k');
        plot(a, b, 'Color', [rho(v), rho(v), 0]);
        hold on;
    end
end