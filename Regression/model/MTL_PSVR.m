function [ yTest, Time ] = MTL_PSVR( xTrain, yTrain, xTest, opts )
%MTL_PSVR 此处显示有关此函数的摘要
% Multi-task proximal support vector machine
%   此处显示详细说明

%% Parse opts
    lambda = opts.lambda;
    nu = opts.nu;
    kernel = opts.kernel;
    TaskNum = length(xTrain);
    rate = TaskNum/lambda;
    
%% Prepare
    tic;
    % 得到所有的样本和标签以及任务编号
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
    C = A; % 保留核变换矩阵
    A = Kernel(A, C, kernel); % 非线性变换
    
%% Fit
    e = cell(TaskNum);
    P = [];
    for i = 1 : TaskNum
        et = ones(size(Y(Tt,:)));
        At = A(T==t,:);
        Pt = At*At'+et*et'+1/nu*rate;
        P = blkdiag(P, Pt);
        e{t} = et;
    end
    Alpha = (A'*A+rate*P)\Y;
    
%% Get W
    W = cell(TaskNum, 1);
    W0 = A'*Alpha;
    for t = 1 : TaskNum
        Tt = T==t;
        A_t = A(Tt,:);
        Alpha_t = Alpha(Tt,:);
        Wt = W0 + rate*A_t'*Alpha_t;
        Gamma = -rate*Alpha_t'*e{t};
        W{t} = [Wt; Gamma];
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