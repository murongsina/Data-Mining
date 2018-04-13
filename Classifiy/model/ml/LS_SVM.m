function [ yTest, Time, w ] = LS_SVM( xTrain, yTrain, xTest, opts )
%LS_SVR 此处显示有关此函数的摘要
% Least Square Support Vector Machine
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
    I = eye(E);
    H = Z*Z' + 1/gamma*I;
    A = [H Y;Y' 0];
    b = [E; 0];
    w = A\b;
    Time = toc;
    
%% Predict
    e = ones(length(xTest));
    yTest = sign([Kernel(xTest, X, kernel) e]*w);
    
end

