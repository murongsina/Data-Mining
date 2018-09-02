function [ yTest, Time ] = MTL_aLS_SVM( xTrain, yTrain, xTest, opts )
%MTL_aLS_SVM 此处显示有关此函数的摘要
% Multi-task asymmetric least squares support vector machine
%   此处显示详细说明

%% Parse opts
C1 = opts.C1;
C2 = opts.C2;
rho = opts.rho;
kernel = opts.kernel;
solver = opts.solver;
TaskNum = length(xTrain);

%% Fit
tic;
[ X, Y, T ] = GetAllData( xTrain, yTrain, TaskNum );
XX = Kernel(X, X, kernel);
Q = Y.*XX.*Y';
P = sparse(0, 0);
for t = 1 : TaskNum
    Tt = T==t;
    P = blkdiag(P, Q(Tt,Tt));
end
K = Q + 1/C1 * P;
H = [K,-K;-K,K];
% R
e = ones(size(Y));
I = speye(size(K));
LT = I/(rho*rho);
RT = I/(rho*(1-rho));
LB = I/((1-rho)*rho);
RB = I/((1-rho)*(1-rho));
R = [LT, RT; LB, RB];
% Kernel matrix
G = H + 1/C2*R;
f = [-e;e];
Aeq = [Y;-Y]';
beq = 0;
lb = zeros(size(f));
ub = Inf(size(f));
Gamma = quadprog(G,f,[],[],Aeq,beq,lb,ub,[],solver);
Gamma = reshape(Gamma, length(Y), 2);
Alpha = Gamma(:,1);
Beta = Gamma(:,2);
Theta = Alpha - Beta;

%% Get b
b = zeros(TaskNum, 1);
for t = 1 : TaskNum
    Tt= T==t;
    alpha = Alpha(Tt,1);
    beta = Beta(Tt,1);
    % support vectors
    qt = 1/C2*(alpha/rho+beta/(1-rho));
    y_hat1 = (1-1/rho*qt)./Y(Tt,1);
    y_hat2 = (1-1/(1-rho)*qt)./Y(Tt,1);
    xwt = XX(Tt,:).*Y'*Theta+XX(Tt,Tt).*Y(Tt,1)'*Theta(Tt,1)/C1;
    b_hat1 = y_hat1 - xwt;
    b_hat2 = y_hat2 - xwt;
    b(t, 1) = mean([b_hat1(alpha>0); b_hat2(beta>0)]);
end
Time = toc;

%% Predict
TaskNum = length(xTest);
yTest = cell(TaskNum, 1);
for t = 1 : TaskNum
    Tt = T==t;
    Ht = Kernel(xTest{t}, X, kernel);
    y0 = Ht.*Y'*Theta;
    yt = Ht(:,Tt).*Y(Tt,1)'*Theta(Tt,1)/C1;
    y = sign(y0 + yt + b(t,1));
    y(y==0) = 1;
    yTest{t} = y;
end

end

