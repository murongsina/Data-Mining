classdef Utils
    %UTILS 此处显示有关此类的摘要
    % 工具集
    %   此处显示详细说明
    
    properties
    end
    
    methods (Static)
        function [ Y ] = K( Kernel, U, V, p1, p2, p3 )
        %KERNEL 此处显示有关此函数的摘要
        % 核函数
        %   此处显示详细说明
        % 参数：
        %     Kernel    -核函数
        %     U         -矩阵U
        %     V         -矩阵V
        %     p1~p3     -核函数参数

            switch Kernel
                case 'linear'
                    % Linear Kernel
                    % disp('You are using a Linear Kernal')
                    Y = U*V.';
                case 'poly'
                    % Polynomial Kernel
                    % disp('You are using a Polynomial Kernal')
                    Y = (p1*U*V'+p2).^p3;
                case 'rbf'
                    % Gaussian Kernel
                    % disp('You are using a RBF Kernal')
                    D = XYDist(U, V);
                    Y = exp(-D.^2/(2*p1.^2));
                case 'sigmoid'
                    % Sigmoid Kernel
                    Y = tanh(p1*U*V'+p2);
                case 'log'
                    % Log Kernel
                    D = XYDist(U, V);
                    Y = -log(1+D.^p1);
                otherwise
                    disp('Please enter a Valid kernel choice ')
                    Y = [ ];
            end
        end
        function [ A ] = Cond( H )
        %COND 此处显示有关此函数的摘要
        % 调整核矩阵
        %   此处显示详细说明
        % 参数：
        %     H     -核矩阵
        %     A     -调整后矩阵

            if (abs(cond(H)) > 1e+10)
                A = H + 0.00000001*eye(size(H));
            else
                A = H;
            end            
        end
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