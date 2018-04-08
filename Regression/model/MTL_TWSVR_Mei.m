function [ yTest, Time ] = MTL_TWSVR_Mei( xTrain, yTrain, xTest, opts )
%MTL_TWSVR_MEI 此处显示有关此函数的摘要
% 2018年4月3日17:12:10
%   此处显示详细说明

%% Parse opts
    T = length(xTrain);
    C1 = opts.C1;
    C2 = opts.C2;
    eps1 = opts.eps1;
    eps2 = opts.eps2;
    rho = T/opts.rho;
    lambda = T/opts.lambda;
    kernel = opts.kernel;
    solver = opts.solver;
    
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
    
    %% 得到Q,P矩阵
    % 得到Q矩阵
    AA = A'*A;
    AA = Utils.Cond(AA);
    AAA = AA\A';
    Q = A*AAA;
    % 得到P矩阵
    P = [];
    AAAt = cell(TaskNum, 1);
    for t = 1 : TaskNum
        At = A(T==t,:);
        AAAt{t} = (At'*At)\At';
        Pt = At*AAAt{t};
        P = blkdiag(P, Pt);
    end
    
%% Fit
    % 求解两个二次规划
    [m, ~] = size(T);
    e = ones(m, 1);
    lb = zeros(m, 1);
    H1 = Q+rho*P;
    H2 = Q+lambda*P;
    QPY = (Q+P)'*Y;
    % MTL_TWSVR1
    ub1 = e*C1;
    Alpha = quadprog(H1,(Y+eps1)-QPY,[],[],[],[],lb,ub1,[],solver);
    % MTL_TWSVR2
    ub2 = e*C2;
    Gamma = quadprog(H2, QPY-(Y-eps2),[],[],[],[],lb,ub2,[],solver);
    
%% Get W
    W = cell(TaskNum, 1);
    U = AAA*(Y - Alpha);
    V = AAA*(Y + Gamma);
    for t = 1 : TaskNum
        Tt = T==t;
        Ut = AAAt{t}*(Y(Tt,:) - rho*Alpha(Tt,:));
        Vt = AAAt{t}*(Y(Tt,:) + lambda*Gamma(Tt,:));
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

