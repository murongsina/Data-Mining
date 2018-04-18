classdef Utils
    %UTILS 此处显示有关此类的摘要
    % 工具集
    %   此处显示详细说明
    
    properties
    end
    
    methods (Static)
        function [ idx, dist, M ] = KnnGraph( X, k )
        %MKNN 此处显示有关此函数的摘要
        % Mutual K Nearest Neighbours
        %   此处显示详细说明
        % 参数：
        %     X    -数据集
        %     k    -近邻数
        % 输出：
        %   idx    -所有样本k近邻矩阵
        %  dist    -所有样本k近邻距离矩阵
        %     M    -Mutual KNN Graph

            [m, ~] = size(X);
            % 求得相互最近邻
            [idx, dist] = knnsearch(X, X, 'K', k + 1,'Distance','euclidean');
            idx = idx(:, 2:k + 1);
            dist = dist(:, 2:k + 1);
            % 构造Mutual KNN Graph
            M = zeros(m, m); % zeros(m, m); % spalloc(m, m, 2*k*m);
            for i = 1 : m
                M(i, idx(i, :)) = 1;%dist(i, :);
            end
            M = (M + M')/2;
        end
    end
end