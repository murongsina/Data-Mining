function [ yTest, Time ] = TWSVM(xTrain, yTrain, opts)
%TWSVM 此处显示有关此类的摘要
% Twin Support Vector Machine
%   此处显示详细说明
    
%% Parse opts
    C1 = opts.C1;
    C2 = opts.C2;

%% Fit
    % 计时
    tic
    % 分割正负类点
    A = xTrain(yTrain==1, :);
    B = xTrain(yTrain==-1, :);
    [m1, ~] = size(A);
    [m2, ~] = size(B);
    [~, n] = size(xTrain);
    e1 = ones(m1, 1);
    e2 = ones(m2, 1);
    % 构造J,Q矩阵
    J = [A e1];
    Q = [B e2];
    J2 = (J'*J);
    Q2 = (Q'*Q);
    % DTWSVM1
    lb1 = zeros(m2,1);
    ub1 = C1*ones(m2,1);
    H1 = Q/J2*Q';
    H1 = Utils.Cond(H1);
    Alpha = quadprog(H1, -e2, [], [], [], [], lb1, ub1);
    u = -J2\Q'*Alpha;
    w1 = u(1:n);
    b1 = u(end);
    % DTWSVM2
    lb2 = zeros(m1, 1);
    ub2 = C2*ones(m1, 1);
    H2 = J/Q2*J';
    H2 = Utils.Cond(H2);
    Beta = quadprog(H2, -e1, [], [], [], [], lb2, ub2);
    v = -Q2\J'*Beta; 
    w2 = v(1:n, :);
    b2 = v(end);
    % 停止计时
    Time = toc;

%% Predict
    D1 = abs(xTest*w1+b1);
    D2 = abs(xTest*w2+b2);
    yTest = sign(D2-D1);
    yTest(yTest==0) = 1;
    
end