function [ yTest, Time ] = TWSVM(xTrain, yTrain, xTest, opts)
%KTWSVM 此处显示有关此类的摘要
% Twin Support Vector Machine
%   此处显示详细说明
    
%% Parse opts
    C1 = opts.C1;
    C2 = opts.C2;
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
    % 最优化参数
    options = optimset('Display', 'notify');
    % 构造核矩阵
    C = [A; B];
    S = [Kernel(A, C, kernel) e1];
    R = [Kernel(B, C, kernel) e2];
    S2 = S'*S;
    R2 = R'*R;
    % KDTWSVM1
%     S2 = Utils.Cond(S2);
    H1 = R/S2*R';
    lb1 = zeros(m2, 1);
    ub1 = ones(m2, 1)*C1;
    Alpha = quadprog(H1,-e2,[],[],[],[],lb1,ub1,[],options);
    z1 = -S2\R'*Alpha;
    u1 = z1(1:n);
    b1 = z1(end);
    % KDTWSVM2
%     R2 = Utils.Cond(R2);
    H2 = S/R2*S';
    lb2 = zeros(m1, 1);
    ub2 = ones(m1, 1)*C2;
    Mu = quadprog(H2,-e1,[],[],[],[],lb2,ub2,[],options);
    z2 = -R2\S'*Mu;
    u2 = z2(1:n);
    b2 = z2(end);
    % 停止计时
    Time = toc;
    
%% Predict
    K = Kernel(xTest, C, kernel);
    D1 = abs(K*u1+b1);
    D2 = abs(K*u2+b2);
    yTest = sign(D2-D1);
    yTest(yTest==0) = 1;

end