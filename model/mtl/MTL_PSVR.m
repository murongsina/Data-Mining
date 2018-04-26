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
[m, ~] = size(Y);
E = ones(m, 1);
I = speye(m, m);

%% Fit
Q = A'*A;
P = sparse(0, 0);
for t = 1 : TaskNum
    Tt = T==t;
    P = blkdiag(P, Q(Tt,Tt) + 1);
end
Alpha = Cond(Q + rate*P + 1/nu*I)\Y;
    
%% Get W
w = cell(TaskNum, 1);
b = zeros(TaskNum, 1);
w0 = A'*Alpha;
for t = 1 : TaskNum
    Tt = T==t;
    A_t = A(Tt,:);
    Alpha_t = Alpha(Tt,:);
    w{t} = w0 + rate*A_t'*Alpha_t;
    b(t) = rate*E(Tt,:)'*Alpha_t;
end
Time = toc;

%% Predict
[ TaskNum, ~ ] = size(xTest);
yTest = cell(TaskNum, 1);
for t = 1 : TaskNum
    yTest{t} = Kernel(xTest{t}, C, kernel) * w{t} + b(t);
end
    
end