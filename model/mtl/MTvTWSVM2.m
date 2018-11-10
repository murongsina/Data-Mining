function [ yTest, Time ] = MTvTWSVM2( xTrain, yTrain, xTest, opts )
%MTVTWSVM 此处显示有关此函数的摘要
% Multi-Task $\nu$-Twin Support Vector Machine v2
%   此处显示详细说明

%% Parse opts
v1 = opts.v1;
v2 = opts.v1;
mu1 = opts.rho;
mu2 = opts.rho;
kernel = opts.kernel;
solver = opts.solver;
TaskNum = length(xTrain);
symmetric = @(H) (H+H')/2;
    
%% Prepare
tic;
% 得到所有的样本和标签以及任务编号
[ X, Y, ~, N ] = GetAllData(xTrain, yTrain, TaskNum);
% 分割正负类点
Yp = Y==1;
Yn = Y==-1;
A = X(Yp,:);
B = X(Yn,:);
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
CE = mat2cell(E, N(1,:));
CF = mat2cell(F, N(2,:));
if isfield(solver, 'parallel')
    parfor t = 1 : TaskNum
        EEFc{t} = Cond(CE{t}'*CE{t})\(CF{t}');
        FFEc{t} = Cond(CF{t}'*CF{t})\(CE{t}');
    end
    solver = rmfield(solver, 'parallel');
else
    for t = 1 : TaskNum
        EEFc{t} = Cond(CE{t}'*CE{t})\(CF{t}');
        FFEc{t} = Cond(CF{t}'*CF{t})\(CE{t}');
    end
end
% 构造P,S对角阵
P = sparse(0, 0);
S = sparse(0, 0);
for t = 1 : TaskNum
    P = blkdiag(P, CF{t}*EEFc{t});
    S = blkdiag(S, CE{t}*FFEc{t});
end

%% Fit
% MTVTWSVM1
H1 = mu1*Q + TaskNum*(1-mu1)*P;
Alpha = quadprog(symmetric(H1),[],-e2',-v1,[],[],zeros(m2, 1),e2/m2,[],solver);
CAlpha = mat2cell(Alpha, N(2,:));
% MTVTWSVM2
H2 = mu2*R + TaskNum*(1-mu2)*S;
Gamma = quadprog(symmetric(H2),[],-e1',-v2,[],[],zeros(m1, 1),e1/m1,[],solver);
CGamma = mat2cell(Gamma, N(1,:));

%% GetWeight
u = -EEF*(mu1*Alpha);
v = FFE*(mu2*Gamma);
U = cell(TaskNum, 1);
V = cell(TaskNum, 1);
parfor t = 1 : TaskNum
    U{t} = u - EEFc{t}*(TaskNum*(1-mu1)*CAlpha{t});
    V{t} = v + FFEc{t}*(TaskNum*(1-mu2)*CGamma{t});
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

