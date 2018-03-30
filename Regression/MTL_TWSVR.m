function [ yTest, Time ] = MTL_TWSVR(xTrain, yTrain, xTest, opts)
%MTL_TWSVR 此处显示有关此类的摘要
% Multi-Task Twin Support Vector Machine
%   此处显示详细说明

%% Parse opts
    C1 = opts.C1;         % 参数1
    C2 = opts.C2;         % 参数2
    eps1 = opts.eps1;     % 参数3
    eps2 = opts.eps2;     % 参数4
    kernel = opts.Kernel; % 核函数参数

%% Prepare
    tic;
    % 得到所有的样本和标签以及任务编号
    [ TaskNum, ~ ] = size(xTrain);  
    A = []; Y = []; T = [];
    for t = 1 : TaskNum
        % 得到任务i的H矩阵
        Xt = xTrain{t};
        A = cat(1, A, Xt);
        % 得到任务i的Y矩阵
        Yt = yTrain{t};
        Y = cat(1, Y, Yt);
        % 分配任务下标
        [m, ~] = size(Yt);
        Tt = t*ones(m, 1);
        T = cat(1, T, Tt);
    end
    [m, ~] = size(A);
    e = ones(m, 1);
    C = A; % 保留核变换矩阵
    A = [Kernel(A, C, kernel) e]; % 非线性变换
    % 得到f和g
    f = Y + eps2;
    g = Y - eps1;
    % 得到P矩阵
    P = [];
    TaskNum = 5;
    Rts = cell(TaskNum, 1);
    for t = 1 : TaskNum
        At = A(T==t,:);
        Rts{t} = (At'*At)\At';
        Pt = At*Rts{t};
        P = blkdiag(P, Pt);
    end
    % 二次规划的H矩阵
    H = (A/(A'*A))*A' + P;
    %% Fit
    % 求解两个二次规划
    [m, ~] = size(T);
    e = ones(m, 1);
    lb = zeros(m, 1);
    H = Utils.Cond(H);
    % MTL_TWSVR1
    ub1 = e*C1;
    Alpha = quadprog(H,g-H'*f,[],[],[],[],lb,ub1,[]);
    % MTL_TWSVR2
    ub2 = e*C2;
    Gamma = quadprog(H,H'*g-f,[],[],[],[],lb,ub2,[]);

%% GetWeight
    W = cell(TaskNum, 1);
    U = (A'*A)\A'*(f - Alpha);
    V = (A'*A)\A'*(g + Gamma);
    for t = 1 : TaskNum
        Tt = T==t;
        Ut = Rts{t}*(f(Tt,:) - Alpha(Tt,:));
        Vt = Rts{t}*(g(Tt,:) + Gamma(Tt,:));
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
        KAte = [Kernel(At, C, opts.Kernel) et];
        yTest{t} = KAte * W{t};
    end

end