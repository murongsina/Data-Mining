function [ yTest, Time ] = DMTSVM( xTrain, yTrain, xTest, opts )
%DMTSVM 此处显示有关此函数的摘要
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
symmetric = @(H) (H+H')/2;
    
%% Prepare
tic;
% 得到所有的样本和标签以及任务编号
[ X, Y, ~, N ] = GetAllData(xTrain, yTrain, TaskNum);
% 分割正负类点
A = X(Y==1,:);
B = X(Y==-1,:);
[m1, ~] = size(A);
[m2, ~] = size(B);
% 核函数
e1 = ones(m1, 1);
e2 = ones(m2, 1);
E = [Kernel(A, X, kernel) e1];
F = [Kernel(B, X, kernel) e2];
% 得到Q,R矩阵
EEF = Cond(E'*E)\F';
FFE = Cond(F'*F)\E';
Q = F*EEF;
R = E*FFE;
% 并行化处理
EEFc = cell(TaskNum, 1);
FFEc = cell(TaskNum, 1);
Ec = mat2cell(E, N(1,:));
Fc = mat2cell(F, N(2,:));
if isfield(solver, 'parallel')
    parfor t = 1 : TaskNum
        EEFc{t} = Cond(Ec{t}'*Ec{t})\(Fc{t}');
        FFEc{t} = Cond(Fc{t}'*Fc{t})\(Ec{t}');
    end
    solver = rmfield(solver, 'parallel');
else
    for t = 1 : TaskNum
        EEFc{t} = Cond(Ec{t}'*Ec{t})\(Fc{t}');
        FFEc{t} = Cond(Fc{t}'*Fc{t})\(Ec{t}');
    end
end
% 得到P,S矩阵
P = sparse(0, 0);
S = sparse(0, 0);
for t = 1 : TaskNum
    P = blkdiag(P, Fc{t}*EEFc{t});
    S = blkdiag(S, Ec{t}*FFEc{t});
end

%% Fit
% DMTSVM1
H1 = Q + 1/rho*P;
Alpha = quadprog(symmetric(H1),-e2,[],[],[],[],zeros(m2, 1),C1*e2,[],solver);
CAlpha = mat2cell(Alpha, N(2,:));
% DMTSVM2
H2 = R + 1/lambda*S;
Gamma = quadprog(symmetric(H2),-e1,[],[],[],[],zeros(m1, 1),C2*e1,[],solver);
CGamma = mat2cell(Gamma, N(1,:));

%% GetWeight
u = -EEF*Alpha;
v = FFE*Gamma;
U = cell(TaskNum, 1);
V = cell(TaskNum, 1);
for t = 1 : TaskNum
    U{t} = u - EEFc{t}*(1/rho*CAlpha{t});
    V{t} = v + FFEc{t}*(1/lambda*CGamma{t});
end
Time = toc;
    
%% Predict
TaskNum = length(xTest);
yTest = cell(TaskNum, 1);
parfor t = 1 : TaskNum
    At = xTest{t};
    [m, ~] = size(At);
    et = ones(m, 1);
    KAt = [Kernel(At, X, kernel) et];
    D1 = abs(KAt * U{t})/norm(U{t}(1:end-1));
    D2 = abs(KAt * V{t})/norm(V{t}(1:end-1));
    yt = sign(D2-D1);
    yt(yt==0) = 1;
    yTest{t} = yt;
end

end
