function [ yTest, Time, w ] = LS_TWSVR( xTrain, yTrain, xTest, opts )
%LS_TWSVR 此处显示有关此函数的摘要
% Primal least squares twin support vector regression
%   此处显示详细说明

%% Parse opts
    eps1 = opts.eps1;
    eps2 = opts.eps1;
    kernel = opts.kernel;
    
%% Fit
    tic;
    A = xTrain;
    Y = yTrain;
    e = ones(size(Y));
    G = [Kernel(A, A, kernel) e];
    f = Y - eps1;
    h = Y + eps2;
    
    GG = G'*G;
    GG = Utils.Cond(GG);
    % LS_TWSVR1
    u1 = GG\G'*f;
    % LS_TWSVR2
    u2 = GG\G'*h;
    w = (u1+u2)/2;
    Time = toc;
    
%% Predict
    [m, ~] = size(xTest);
    e = ones(m, 1);
    yTest = [Kernel(xTest, A, kernel), e]*w;
    
end

