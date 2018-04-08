function [ yTest, Time ] = MTL_PSVR( xTrain, yTrain, xTest, opts )
%MTL_PSVR 此处显示有关此函数的摘要
% Multi-task proximal support vector machine
%   此处显示详细说明

%% Parse opts
    lambda = opts.lambda;
    mu = opts.mu;
    kernel = opts.kernel;
    TaskNum = length(xTrain);
    
%% Fit
    A = xTrain;
    Y = yTrain;
    e = ones(size(yTrain));
    P = [];
    for i = 1 : TaskNum
        Pt = At*At'+et*et'+(lambda/TaskNum*mu);
        P = blkdiag(P, Pt);
    end
    
    Alpha = (A'*A+TaskNum/lambda*P)'*Y;
end