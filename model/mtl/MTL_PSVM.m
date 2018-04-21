function [ yTest, Time, W ] = MTL_PSVM( xTrain, yTrain, xTest, opts )
%MTL_PSVR 此处显示有关此函数的摘要
% Multi-task proximal support vector machine
% ref:Multi-task proximal support vector machine
%   此处显示详细说明

%% Parse opts
    TaskNum = length(xTrain);
    lambda = opts.lambda;
    nu = opts.nu;
    kernel = opts.kernel;
    rate = TaskNum/lambda;
    
%% Prepare
    tic;
    [ A, Y, T ] = GetAllData( xTrain, yTrain, TaskNum );
    C = A;
    A = Kernel(A, C, kernel);
    
%% Fit
    e = cell(TaskNum, 1);
    D = diag(Y);
    P = [];
    for t = 1 : TaskNum
        Tt = T==t;
        At = A(Tt,:);
        Dt = diag(Y(Tt));
        Et = ones(size(Y(Tt,:)));
        Pt = rate*Dt*(At*At'+Et*Et')*Dt+1/nu*eye(Et);
        P = blkdiag(P, Pt);
        e{t} = Et;
    end
    E = ones(size(Y));
    P = sparse(P);
    Alpha = Cond(D*(A'*A)*D+P)\E;
    
%% Get W
    W = cell(TaskNum, 1);
    W0 = A'*D*Alpha;
    for t = 1 : TaskNum
        Tt = T==t;
        At = A(Tt,:);
        Dt = diag(Y(Tt));
        Alpha_t = Alpha(Tt,:);
        Wt = W0 + rate*At'*Dt*Alpha_t;
        Gamma_t = -rate*e{t}'*Dt*Alpha_t;
        W{t} = [Wt; Gamma_t];
    end
    Time = toc;
    
%% Predict
    [ TaskNum, ~ ] = size(xTest);
    yTest = cell(TaskNum, 1);
    for t = 1 : TaskNum
        At = xTest{t};
        [m, ~] = size(At);
        KAt = [Kernel(At, C, kernel) ones(m, 1)];
        yt = sign(KAt * W{t});
        yt(yt==0) = 1;
        yTest{t} = yt;
    end
    
end