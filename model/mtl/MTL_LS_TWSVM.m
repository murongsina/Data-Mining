function [ yTest, Time, U, V ] = MTL_LS_TWSVM(xTrain, yTrain, xTest, opts)
%MTL_LS_TWSVM 此处显示有关此函数的摘要
% Multi-Task Least Square Support Vector Machine
%   此处显示详细说明

%% Parse opts
    C1 = opts.C1;
    C2 = opts.C1;
    rho = opts.rho;
    lambda = opts.rho;
    kernel = opts.kernel;
    TaskNum = length(xTrain);
    
%% Prepare
    tic;
    % 得到所有的样本和标签以及任务编号
    [ C, Y, T ] = GetAllData(xTrain, yTrain, TaskNum);
    [m, ~] = size(C);
    e = ones(m, 1);
    A = C(Y==1);
    B = C(Y==-1);
    A = [Kernel(A, C, kernel) e];
    B = [Kernel(B, C, kernel) e];
    % 得到Q矩阵
    AAB = Cond(A'*A)\B';
    BBA = Cond(B'*B)\A';
    Q = B*AAB;
    R = A*BBA;
    % 得到P矩阵
    P = [];S = [];
    AABt = cell(TaskNum, 1);
    BBAt = cell(TaskNum, 1);
    for t = 1 : TaskNum
        At = A(T==t,:);
        Bt = B(T==t,:);
        AABt{t} = Cond(At'*At)\(Bt');
        BBAt{t} = Cond(Bt'*Bt)\(At');
        P = blkdiag(P, Bt*AABt{t});
        S = blkdiag(S, At*BBAt{t});
    end
    P = sparse(P);
    S = sparse(S);
    
%% Fit
    % MTL-LS-TWSVM1
    e1 = ones(length(B), 1);
    I1 = eye(size(Q));
    Alpha = (Q + TaskNum/rho*P + 1/C1*I1)\e1;
    % MTL-LS-TWSVM2
    e2 = ones(length(A), 1);
    I2 = eye(size(Q));    
    Gamma = (R + TaskNum/lambda*S + 1/C2*I2)\e2;

%% GetWeight
    u = -AAB*Alpha;
    v = BBA*Gamma;
    U = cell(TaskNum, 1);
    V = cell(TaskNum, 1);
    for t = 1 : TaskNum
        Tt = T==t;
        U{t} = u-TaskNum/rho*AABt{t}*Alpha(Tt,:);
        V{t} = v+TaskNum/lambda*BBAt{t}*Gamma(Tt,:);
    end
    Time = toc;
    
%% Predict
    [ TaskNum, ~ ] = size(xTest);
    yTest = cell(TaskNum, 1);
    for t = 1 : TaskNum
        At = xTest{t};
        [m, ~] = size(At);
        et = ones(m, 1);
        KAt = [Kernel(At, C, kernel) et];
        D1 = KAt * U{t};
        D2 = KAt * V{t};
        yt = sign(D2-D1);
        yt(yt==0) = 1;
        yTest{t} = yt;
    end
    
end
