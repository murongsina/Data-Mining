function [ yTest, Time ] = LS_TWSVM(xTrain, yTrain, xTest, opts)
%LSTWSVM 此处显示有关此类的摘要
% Least Square Twin Support Vector Machine
%   此处显示详细说明
    
%% Parse opts
    C1 = opts.C1;
    C2 = opts.C1;
    kernel = opts.kernel;
    
%% Fit
    % 计时
    tic
    % 分割正负类点
    A = xTrain(yTrain==1, :);
    B = xTrain(yTrain==-1, :);
    [m1, ~] = size(A);
    [m2, ~] = size(B);
    n = m1 + m2;
    e1 = ones(m1, 1);
    e2 = ones(m2, 1);
    % 构造核矩阵
    C = [A; B];
    E = [Kernel(A, C, kernel) e1];
    F = [Kernel(B, C, kernel) e2];
    E2 = E'*E;
    F2 = F'*F;
    % LS-TWSVM1
    u1 = -Cond(F2+1/C1*E2)\F'*e2;
    w1 = u1(1:n);
    b1 = u1(end);
    % LS-TWSVM2
    u2 = Cond(E2+1/C2*F2)\E'*e1;
    w2 = u2(1:n);
    b2 = u2(end);
    % 停止计时
    Time = toc;
    
%% Predict
    K = Kernel(xTest, C, kernel);
    D1 = abs(K*w1+b1);
    D2 = abs(K*w2+b2);
    yTest = sign(D2-D1);
    yTest(yTest==0) = 1;
    
end