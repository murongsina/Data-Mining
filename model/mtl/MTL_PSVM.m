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

%% Fit
e = cell(TaskNum, 1);
P = sparse(0, 0);
for t = 1 : TaskNum
    Tt = T==t;
    At = A(Tt,:);
    Yt = Y(Tt,:);
    Et = ones(size(Yt));
    e{t} = Et;
    AE = At*At'+Et*Et';
    Dt = speye(size(AE))*Yt;
    Ht = Dt*AE*Dt;
    It = speye(size(Ht));
    P = blkdiag(P, rate*Ht + 1/nu*It);
end
E = ones(size(Y));
D = diag(Y);
Alpha = Cond(D*(A'*A)*D+P)\E;

%% Get W
W = cell(TaskNum, 1);
W0 = A'*D*Alpha;
for t = 1 : TaskNum
    Tt = T==t;
    At = A(Tt,:);
    Dt = spdiags(diag(Y(Tt)));
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