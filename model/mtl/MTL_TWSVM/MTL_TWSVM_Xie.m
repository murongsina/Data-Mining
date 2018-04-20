function [ yTest, Time ] = MTL_TWSVM_Xie( xTrain, yTrain, xTest, opts )
%MTL_TWSVM_XIE 此处显示有关此函数的摘要
% Multi-Task Twin Support Vector Machine
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
    E = C(Y==1);
    F = C(Y==-1);
    E = [Kernel(E, C, kernel) e];
    F = [Kernel(F, C, kernel) e];
    % 得到Q,R矩阵
    EEF = Cond(E'*E)\F';
    FFE = Cond(F'*F)\E';
    Q = F*EEF;
    R = E*FFE;
    % 得到P,S矩阵
    P = [];
    S = [];
    EEFt = cell(TaskNum, 1);
    FFEt = cell(TaskNum, 1);
    for t = 1 : TaskNum
        Et = E(T==t,:);
        Ft = F(T==t,:);
        EEFt{t} = Cond(Et'*Et)\(Ft');
        FFEt{t} = Cond(Ft'*Ft)\(Et');
        P = blkdiag(P, Ft*EEFt{t});
        S = blkdiag(S, Et*FFEt{t});
    end

%% Fit
    % 求解两个二次规划
    % MTL_TWSVR1_Xie
    e1 = ones(length(F));
    lb1 = zeros(length(F));
    ub1 = C1*e1;
    Alpha = quadprog(Q + 1/rho*P,-e1,[],[],[],[],lb1,ub1,[],solver);
    % MTL_TWSVR2_Xie
    e2 = ones(length(E));
    lb2 = zeros(length(E));
    ub2 = C2*e2;
    Gamma = quadprog(R + 1/lambda*S,-e2,[],[],[],[],lb2,ub2,[],solver);
    
%% GetWeight
    u = -EEF*Alpha;
    v = FFE*Gamma;
    U = cell(TaskNum, 1);
    V = cell(TaskNum, 1);
    for t = 1 : TaskNum
        Tt = T==t;
        U{t} = u - 1/rho*EEFt{t}*Alpha(Tt,:);
        V{t} = v + 1/lambda*FFEt{t}*Gamma(Tt,:);
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

