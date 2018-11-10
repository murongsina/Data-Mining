function [ yTest, Time ] = MCTSVM( xTrain, yTrain, xTest, opts )
%MTCTSVM 此处显示有关此函数的摘要
% Multitask Centroid Twin Support Vector Machine
%   此处显示详细说明

%% Parse opts
C1 = opts.C1;
C2 = opts.C1;
p = opts.p;
q = opts.p;
rho = opts.rho;
lambda = opts.rho;
kernel = opts.kernel;
solver = opts.solver;
TaskNum = length(xTrain);
symmetric = @(H) (H+H')/2;

%% Prepare
tic;
% 得到所有的样本和标签以及任务编号
[ X, Y, T ] = GetAllData(xTrain, yTrain, TaskNum);
% 分割正负类点
Yp = Y==1;
Yn = Y==-1;
A_ = X(Yp,:);
B_ = X(Yn,:);
% reconstruct all tasks
% centroids of all task
A = [A_; p*mean(A_)];
B = [B_; q*mean(B_)];
% centroid of t-th task
AT = cell(TaskNum, 1);
BT = cell(TaskNum, 1);
CT = cell(TaskNum, 1);
YT = cell(TaskNum, 1);
for t = 1 : TaskNum
    AT_ = A_(T(Yp)==t,:);
    BT_ = B_(T(Yn)==t,:);
    AT{t} = [AT_; p*mean(AT_)];
    BT{t} = [BT_; q*mean(BT_)];
    CT{t} = [AT{t}; BT{t}];
    yp = ones(size(AT{t}, 1), 1);
    yn = -ones(size(BT{t}, 1), 1);
    YT{t} = [yp; yn];
end
M = cell2mat(AT);
N = cell2mat(BT);
C = cell2mat(CT);
[ ~, Y, T ] = GetAllData( CT, YT, TaskNum );
Yp = Y==1;
Yn = Y==-1;
% 核函数
E = [Kernel(A, C, kernel) ones(size(A, 1), 1)];
F = [Kernel(B, C, kernel) ones(size(B, 1), 1)];
M = [Kernel(M, C, kernel) ones(size(M, 1), 1)];
N = [Kernel(N, C, kernel) ones(size(N, 1), 1)];
% 单位向量
[m1, ~] = size(M);
[m2, ~] = size(N);
e1 = ones(m1, 1);
e2 = ones(m2, 1);
% 得到Q,R矩阵
EEF = Cond(E'*E)\N';
FFE = Cond(F'*F)\M';
Q = N*EEF;
R = M*FFE;
% 得到P,S矩阵
P = sparse(0, 0);
S = sparse(0, 0);
EEFt = cell(TaskNum, 1);
FFEt = cell(TaskNum, 1);
for t = 1 : TaskNum
    Et = [Kernel(AT{t}, C, kernel) ones(size(AT{t}, 1), 1)];
    Ft = [Kernel(BT{t}, C, kernel) ones(size(BT{t}, 1), 1)];
    EEFt{t} = Cond(Et'*Et)\(Ft');
    FFEt{t} = Cond(Ft'*Ft)\(Et');
    P = blkdiag(P, Ft*EEFt{t});
    S = blkdiag(S, Et*FFEt{t});
end

%% Fit
% 求解两个二次规划
% MCTSVM
H1 = Q + 1/rho*P;
Alpha = quadprog(symmetric(H1),-e2,[],[],[],[],zeros(m2, 1),C1*e2,[],solver);
% MCTSVM
H2 = R + 1/lambda*S;
Gamma = quadprog(symmetric(H2),-e1,[],[],[],[],zeros(m1, 1),C2*e1,[],solver);

%% GetWeight
u = -EEF*Alpha;
v = FFE*Gamma;
U = cell(TaskNum, 1);
V = cell(TaskNum, 1);
for t = 1 : TaskNum
    U{t} = u - 1/rho*EEFt{t}*Alpha(T(Yn)==t,:);
    V{t} = v + 1/lambda*FFEt{t}*Gamma(T(Yp)==t,:);
end
Time = toc;

%% Predict
TaskNum = length(xTest);
yTest = cell(TaskNum, 1);
parfor t = 1 : TaskNum
    At = xTest{t};
    [m, ~] = size(At);
    et = ones(m, 1);
    KAt = [Kernel(At, C, kernel) et];
    D1 = abs(KAt * U{t})/norm(U{t}(1:end-1));
    D2 = abs(KAt * V{t})/norm(V{t}(1:end-1));
    yt = sign(D2-D1);
    yt(yt==0) = 1;
    yTest{t} = yt;
end

end