function [ yTest, Time ] = SVM(xTrain, yTrain, xTest, opts)
%CSVM 此处显示有关此类的摘要
% C-Support Vector Machine
%   此处显示详细说明
    
%% Parse opts
    C = opts.C;            % 参数
    kernel = opts.kernel;  % 核函数

%% Fit
    tic
    [m, ~] = size(xTrain);
    % 二次规划求解
    f = -ones(m, 1);
    lb = zeros(m, 1);
    ub = C*ones(m, 1);
    H = diag(yTrain)*Kernel(xTrain, xTrain, kernel)*diag(yTrain);
    H = Cond(H);
    [ Alpha ] = quadprog(H, f, [], [], [], [], lb, ub, [], []);
    svi = Alpha > 0 & Alpha < C;
    % 停止计时
    Time = toc;

%% Predict
    yTest = sign(Kernel(xTest, xTrain(svi,:), kernel)*diag(yTrain(svi))*Alpha(svi));
    yTest(yTest==0) = 1;
    
end