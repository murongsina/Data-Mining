function [ Xn, Yn, W ] = NDP_PART( X, Y, k, th )
%CSUM 此处显示有关此函数的摘要
% Cosine Sum Sample Selection Part
% 
% 参数：
%   X   -数据集
%   Y   -标签集
%   k   -近邻数
%   th  -余弦和阈值
% 
%   此处显示详细说明
    % 得到维数
    [m, ~] = size(X);
    % 筛选样本
    W = zeros(m, 1);
    % 得到距离
    M = DIST(X);
    % Step 1: Solve the problem of k-nearest neighbors on D;
    for x = 1 : m
        knn = KNN(M, x, k);
        % Calculate cosine sum according to formula (6) or formula (8);
        % Definition 3-1(mass center).
        xk = mean(X(knn, :));
        % Definition 3-2(sample-neighbor angle).
        x0k = X(x,:) - xk; % x0 - xk, 1*n 矩阵
        x0i = repmat(X(x,:), k, 1) - X(knn,:); % x0 - xi kn * n
        % Definition 3-3(cosine sum).
        csum = 0;
        for i = 1 : k
            B = x0i(i,:);
            cosine = (x0k*B')/(norm(x0k)*norm(B));
            csum = csum + cosine;
        end
        W(x) = csum;
    end
    % Step 2: preserve the samples, whose cosine sum is greater than th;
%     if csum > th
%         W(x) = 1;
%     end
    idx = find(W > th);
    Xn = X(idx,:); Yn = Y(idx,:);
end