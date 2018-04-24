function [ yTest, Time ] = MTL_LS_TWSVM(xTrain, yTrain, xTest, opts)
%MTL_LS_TWSVM 此处显示有关此函数的摘要
% Multi-Task Least Square Support Vector Machine
%   此处显示详细说明

%% Parse opts
C1 = opts.C1;
C2 = opts.C1;
rho = opts.rho;
lambda = opts.rho;
kernel = opts.kernel;
TaskNum = length(xTrain);

%% Prepare
tic;
% 得到所有的样本和标签以及任务编号
[ C, Y, T ] = GetAllData(xTrain, yTrain, TaskNum);
% 分割正负类点
Yp = Y==1;
Yn = Y==-1;
A = C(Yp,:);
B = C(Yn,:);
[m1, ~] = size(A);
[m2, ~] = size(B);
% 核函数
e1 = ones(m1, 1);
e2 = ones(m2, 1);
A = [Kernel(A, C, kernel) e1];
B = [Kernel(B, C, kernel) e2];
% 得到Q矩阵
AAB = Cond(A'*A)\B';
BBA = Cond(B'*B)\A';
Q = B*AAB;
R = A*BBA;
% 得到P矩阵
P = sparse(0, 0);
S = sparse(0, 0);
AABt = cell(TaskNum, 1);
BBAt = cell(TaskNum, 1);
for t = 1 : TaskNum
    At = A(T(Yp)==t,:);
    Bt = B(T(Yn)==t,:);
    AABt{t} = Cond(At'*At)\(Bt');
    BBAt{t} = Cond(Bt'*Bt)\(At');
    P = blkdiag(P, Bt*AABt{t});
    S = blkdiag(S, At*BBAt{t});
end

%% Fit
% MTL-LS-TWSVM1
I = speye(size(Q));
Alpha = Cond(Q + TaskNum/rho*P + 1/C1*I)\e2;
% MTL-LS-TWSVM2
I = speye(size(R));
Gamma = Cond(R + TaskNum/lambda*S + 1/C2*I)\e1;

%% GetWeight
u = -AAB*Alpha;
v = BBA*Gamma;
U = cell(TaskNum, 1);
V = cell(TaskNum, 1);
for t = 1 : TaskNum
    nt = T(Yn)==t;
    pt = T(Yp)==t;
    U{t} = u-TaskNum/rho*AABt{t}*Alpha(nt,:);
    V{t} = v+TaskNum/lambda*BBAt{t}*Gamma(pt,:);
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
    D1 = KAt * U{t};
    D2 = KAt * V{t};
    yt = sign(D2-D1);
    yt(yt==0) = 1;
    yTest{t} = yt;
end

end