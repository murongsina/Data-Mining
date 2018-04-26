function [ yTest, Time ] = MTL_PSVM( xTrain, yTrain, xTest, opts )
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
[m, ~] = size(Y);
E = ones(m, 1);
I = speye(m, m);

%% Fit
% Q
D = I.*Y;
H = A*A';
% P
P = sparse(0, 0);
for t = 1 : TaskNum
    Tt = T==t;
    At = A(Tt,:);
    Dt = D(Tt,Tt);
    P = blkdiag(P, Dt*(H(At,At) + 1)*Dt);
end
Alpha = Cond(D*H*D + TaskNum/lambda*P + 1/nu*I)\E;

%% Get W
w = cell(TaskNum, 1);
b = zeros(TaskNum, 1);
w0 = DA'*Alpha;
for t = 1 : TaskNum
    Tt = T==t;
    DtAlpha_t = D(Tt,Tt)*Alpha(Tt,:);
    w{t} = w0 + rate*A(Tt,:)'*DtAlpha_t;
    b(t) = rate*sum(DtAlpha_t);
end
Time = toc;

%% Predict
[ TaskNum, ~ ] = size(xTest);
yTest = cell(TaskNum, 1);
for t = 1 : TaskNum
    yt = sign(Kernel(xTest{t}, C, kernel) * w{t} + b(t));
    yt(yt==0) = 1;
    yTest{t} = yt;
end
    
end