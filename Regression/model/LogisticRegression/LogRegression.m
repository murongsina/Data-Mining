function [ yTest, Time ] = LogRegression( xTrain, yTrain, xTest, opts)
%LOGREGRESSION 此处显示有关此函数的摘要
% Logistic Regression
%   此处显示详细说明

    Optimizer = opts.Optimizer;
    NumIter = opts.NumIter;
    
    % Logistic梯度优化
    if Optimizer == 'SGA'
        W = SGA(xTrain, yTrain, NumIter);
    else
        W = BGA(xTrain, yTrain, NumIter);
    end
    
    

%% 批量梯度上升
    function [ W ] = BGA( X, Y, NumIter )
    %BGD 此处显示有关此函数的摘要
    %   此处显示详细说明
        if ismatrix(X) == 1
            [~, n] = size(X);
        end

        alpha = 0.001;
        W = ones(n, 1);

        for k = 1 : NumIter
            H = Sigmoid(X * W);
            E = Y - H;
            W = W + alpha * X.' * E; % 一阶梯度
            % 二阶牛顿法
    %         D1 = -X.'*E;
    %         D2 = X.'.*X.*H.*(1-H);
    %         W = W + alpha * D2\D1;
        end
    end

%% 随机梯度上升
    function [ W ] = SGA( X, Y, NumIter )
    %SGA 此处显示有关此函数的摘要
    %   此处显示详细说明
        if ismatrix(X) == 1
            [m, n] = size(X);
        end
    %    alpha = 0.01;
        weights = ones(n);
        for j = 1 : NumIter
            for i = 1 : m
                alpha = 4 / (1.0 + j + i) + 0.01;
                rand_index = randperm(m, 1);
                h = Sigmoid(sum(X(rand_index) * weights));
                e = Y(rand_index) - h;
                weights = weights + alpha*e*X(rand_index);
            end
        end
        W = weights;
    end

end

