function [ yTest, Time ] = LS_SVR(xTrain, yTrain, xTest, opts)
%LS_SVR 此处显示有关此函数的摘要
% Least Square Support Vector Regression
%   此处显示详细说明

%% Parse opts
    gamma = opts.gamma;
    kernel = opts.kernel;

%% Fit
    tic;
    X = xTrain;
    Y = yTrain;
    Z = Kernel(X, X, kernel);
    E = ones(size(Y));
    I = diag(E);
    H = Z*Z' + 1/gamma*I;
    A = [H E;E' 0];
    b = [Y; 0];
    w = A\b;
    Time = toc;
    
%% Predict
    [m, ~] = size(xTest);
    yTest = [Kernel(xTest, X, kernel) ones(m, 1)]*w;
    
end