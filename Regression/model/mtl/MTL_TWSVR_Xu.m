function [ yTest, Time, W ] = MTL_TWSVR_Xu( xTrain, yTrain, xTest, opts )
%MTL_TWSVR_XU 此处显示有关此函数的摘要
% K-nearest neighbor-based weighted twin support vector regression
% MTL Xu's model
%   此处显示详细说明

%% Parse opts
    C1 = opts.C1;
    C2 = opts.C1;
    eps1 = opts.eps1;
    eps2 = opts.eps1;
    kernel = opts.kernel;
    solver = opts.solver;
    TaskNum = length(xTrain);
    
%% Prepare
    tic;
    [ A, Y, T ] = GetAllData( xTrain, yTrain, TaskNum );
    [m, ~] = size(A);
    e = ones(m, 1);
    C = A;
    % 得到P矩阵
    A = [Kernel(A, C, kernel) e];
    P = [];
    AAAt = cell(TaskNum, 1);
    for t = 1 : TaskNum
        At = A(T==t,:);
        AAAt{t} = Cond(At'*At)\At';
        P = blkdiag(P, At*AAAt{t});
    end
    % 二次规划的H矩阵
    AAA = Cond(A'*A)\A';
    H = A*AAA + P;
    
%% Fit
    % 求解两个二次规划
    [m, ~] = size(T);
    e = ones(m, 1);
    lb = zeros(m, 1);
    HTY = H'*Y;
    % MTL_TWSVR1
    ub1 = e*C1;
    Alpha = quadprog(H,(Y+eps1)-HTY,[],[],[],[],lb,ub1,[],solver);
    % MTL_TWSVR2
    ub2 = e*C2;
    Gamma = quadprog(H,HTY-(Y-eps2),[],[],[],[],lb,ub2,[],solver);
    
%% GetWeight
    W = cell(TaskNum, 1);
    U = AAA*(Y - Alpha);
    V = AAA*(Y + Gamma);
    for t = 1 : TaskNum
        Tt = T==t;
        Ut = AAAt{t}*(Y(Tt,:) - Alpha(Tt,:));
        Vt = AAAt{t}*(Y(Tt,:) + Gamma(Tt,:));
        Uts = U + Ut;
        Vts = V + Vt;
        W{t} = (Uts + Vts)/2;
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
        yTest{t} = KAt * W{t};
    end
    
end