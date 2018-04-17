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

