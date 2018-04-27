function [ yTest, Time ] = MTL_TWSVM_Xie( xTrain, yTrain, xTest, opts )
%MTL_TWSVM_XIE 此处显示有关此函数的摘要
% Multi-Task Twin Support Vector Machine
%   此处显示详细说明

%% Parse opts
C1 = opts.C1;
C2 = opts.C1;
rho = opts.rho;
lambda = opts.rho;
kernel = opts.kernel;
solver = opts.solver;
TaskNum = length(xTrain);
    
%% Prepare
tic;
% 得到所有的样本和标签以及任务编号
[ C, Y, T ] = GetAllData(xTrain, yTrain, TaskNum);
% 分割正负类点
Yn = Y==-1;
Yp = Y==1;
E = C(Yp,:);
F = C(Yn,:);
[m1, ~] = size(E);
[m2, ~] = size(F);
% 核函数
e1 = ones(m1, 1);
e2 = ones(m2, 1);
E = [Kernel(E, C, kernel) e1];
F = [Kernel(F, C, kernel) e2];
% 得到Q,R矩阵
EEF = Cond(E'*E)\F';
FFE = Cond(F'*F)\E';
Q = F*EEF;
R = E*FFE;
% 得到P,S矩阵
P = sparse(0, 0);
S = sparse(0, 0);
EEFt = cell(TaskNum, 1);
FFEt = cell(TaskNum, 1);
for t = 1 : TaskNum
    Et = E(T(Yp)==t,:);
    Ft = F(T(Yn)==t,:);
    EEFt{t} = Cond(Et'*Et)\(Ft');
    FFEt{t} = Cond(Ft'*Ft)\(Et');
    P = blkdiag(P, Ft*EEFt{t});
    S = blkdiag(S, Et*FFEt{t});
end

%% Fit
% 求解两个二次规划
% MTL_TWSVR1_Xie
H1 = Q + 1/rho*P;
Alpha = quadprog(H1,-e2,[],[],[],[],zeros(m2, 1),C1*e2,[],solver);
% MTL_TWSVR2_Xie
H2 = R + 1/lambda*S;
Gamma = quadprog(H2,-e1,[],[],[],[],zeros(m1, 1),C2*e1,[],solver);

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
