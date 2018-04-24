function [ yTest, Time ] = MTL_LS_TWSVR_Xu( xTrain, yTrain, xTest, opts )
%MTL_LS_TWSVR_Xu 此处显示有关此函数的摘要
% Ref:K-nearest neighbor-based weighted twin support vector regression
%   此处显示详细说明

%% Parse opts
C1 = opts.C1;
C2 = opts.C1;
eps1 = opts.eps1;
eps2 = opts.eps1;
rho = opts.rho;
lambda = opts.rho;
kernel = opts.kernel;
TaskNum = length(xTrain);

%% Prepare
tic;
% 得到所有的样本和标签以及任务编号
[ A, Y, T ] = GetAllData(xTrain, yTrain, TaskNum);
[m, ~] = size(A);
e = ones(m, 1);
C = A;
A = [Kernel(A, C, kernel) e];
% 得到Q矩阵
AAA = Cond(A'*A)\A';
Q = A*AAA;
% 得到P矩阵
P = sparse(0, 0);
AAAt = cell(TaskNum, 1);
for t = 1 : TaskNum
    At = A(T==t,:);
    AAAt{t} = Cond(At'*At)\(At');
    Pt = At*AAAt{t};
    P = blkdiag(P, Pt);
end
H = Q + P;

%% Fit
% 求解两个线性方程
I = speye(size(H));
E = ones(size(Y));
% MTL-LS-TWSVR1-Xu
L1 = (Q + TaskNum/rho*P + 1/C1*I);
R1 = (H - I)*Y - eps1*E;
Alpha = L1\R1;
% MTL-LS-TWSVR2-Xu
L2 = (Q + TaskNum/lambda*P + 1/C2*I);
R2 = (I - H)*Y - eps2*E;
Gamma = L2\R2;

%% GetWeight
W = cell(TaskNum, 1);
U = AAA*(Y - Alpha);
V = AAA*(Y + Gamma);
for t = 1 : TaskNum
    Tt = T==t;
    Ut = AAAt{t}*(Y(Tt,:) - TaskNum/rho*Alpha(Tt,:));
    Vt = AAAt{t}*(Y(Tt,:) + TaskNum/lambda*Gamma(Tt,:));
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