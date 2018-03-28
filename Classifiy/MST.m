function [ mst ] = MST( X, start )
%MST 此处显示有关此函数的摘要
% 最小生成树
%   此处显示详细说明
    [m,~] = size(X);
    % 初始化距离矩阵，已访问表，最小生成树
    matrix = zeros(m,m);
    visited = zeros(m,1);
    path = zeros(m,1);
    distance = zeros(m,1);
    % 计算点之间的距离
    for i = 1 : m
        for j = i + 1 : m
            d = norm(X(i,:)-X(j,:));
            matrix(i,j) = d;
            matrix(j,i) = d;
        end
    end
    % 初始化到起始点的距离，路径
    for i = 1 : m
        % 上一节点为start
        path(i, 1) = start;
        % 到起始点的距离
        distance(i, 1) = matrix(start, i);
    end
    % 标记start已访问
    visited(start,1) = 1;
    path(start,1) = start;
    distance(start,1) = 0;
    % 最小生成树Prim算法
    for i = 1 : m
        % 找离当前生成树最近的顶点的minid
        min = Inf;
        mid = start;
        for j = 1 : m
            if visited(j,1) == 0 && distance(j) < min
                mid = j;
                min = distance(j,1);
            end
        end
        % 回到起始点
        if mid == start
            break;
        end
        % 标记minid已访问
        visited(mid,1) = 1;
        % 更新distance(j)到上一个节点的距离
        for j = 1 : m
            % 如果节点未访问，且到当前访问节点距离最近
            if visited(j) == 0 && matrix(mid,j) < distance(j,1)
                distance(j,1) = matrix(mid,j);
                path(j,1) = mid; 
            end
        end
    end
    mst = path;
end