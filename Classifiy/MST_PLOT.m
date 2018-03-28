function [ matrix, idx ] = MST_PLOT( X, mst )
%PLOT_MST 此处显示有关此函数的摘要
% 绘制MST，转换MST为邻接矩阵
% 此处显示详细说明
    [m,~] = size(X);
    matrix = zeros(m, m);
    reduce = zeros(m, 1);
    % 绘制最小生成树
    for i = 1 : m
        u = i;
        v = mst(i, 1);
        % 用邻接矩阵表示最小生成树
        matrix(u, v) = 1;
        matrix(v, u) = 1;
        % 记录相关数据点
        if X(u,3) ~= X(v,3)
            reduce(u) = 1;
            reduce(v) = 1;
        end
        % 绘制连线
        x = [X(u,1) X(v,1)];
        y = [X(u,2) X(v,2)];
        plot(x, y, '-b');
        hold on;
    end
    idx = find(reduce==1);
end

