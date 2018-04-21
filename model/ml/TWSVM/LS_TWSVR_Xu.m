function [ yTest, Time ] = LS_TWSVR_Xu(xTrain, yTrain, xTest, opts)
%LS_TWSVR_XU 此处显示有关此函数的摘要
% Ref:K-nearest neighbor-based weighted twin support vector regression
%   此处显示详细说明

%% Parse opts
    C1 = opts.C1;
    C2 = opts.C1;
    eps1 = opts.eps1;
    eps2 = opts.eps1;
    kernel = opts.kernel;
    
%% Fit
    tic;
    A = xTrain;
    Y = yTrain;
    C = A;
    e = ones(size(Y));
    A = [Kernel(A, C, kernel) e];
    AAA = Cond(A'*A)\A';
    Q = A*AAA;
    I = eye(size(Q));
    E = ones(size(Y));
    L1 = (Q + 1/C1*I);
    R1 = (Q - I)*Y - eps1*E;
    Alpha = L1\R1;
    L2 = (Q + 1/C2*I);
    R2 = (I - Q)*Y - eps2*E;
    Gamma = L2\R2;
    u = AAA*(Y - Alpha);
    v = AAA*(Y + Gamma);
    w = (u + v)/2;
    Time = toc;
    
%% Predict
    [m, ~] = size(xTest);
    yTest = [Kernel(xTest, C, kernel), ones(m, 1)]*w;
end
