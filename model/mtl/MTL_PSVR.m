function [ yTest, Time ] = MTL_PSVR( xTrain, yTrain, xTest, opts )
%MTL_PSVR 此处显示有关此函数的摘要
% Multi-task proximal support vector regression
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
P = sparse(0, 0);
for t = 1 : TaskNum
    Tt = T==t;
    At = A(Tt,:);
    Yt = Y(Tt,:);
    et = ones(size(Yt));
    It = speye(size(Yt));
    Pt = At*At'+et*et'+1/(rate*nu)*It;
    P = blkdiag(P, Pt);
    e{t} = et;
end
Alpha = Cond(A'*A+rate*P)\Y;
    
%% Get W
W = cell(TaskNum, 1);
W0 = A'*Alpha;
for t = 1 : TaskNum
    Tt = T==t;
    A_t = A(Tt,:);
    Alpha_t = Alpha(Tt,:);
    Wt = W0 + rate*A_t'*Alpha_t;
    Gamma_t = -rate*Alpha_t'*e{t};
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
    yTest{t} = KAt * W{t};
end
    
end