function [ yTest, Time ] = RMMTL( xTrain, yTrain, xTest, opts )
%RMMTL 此处显示有关此函数的摘要
% Relative Margin Multi-Task Learning
%   此处显示详细说明

%% Parse opts
c = opts.C;
lambda = opts.lambda;
r = opts.R;
kernel = opts.kernel;
solver = opts.solver;
TaskNum = length(xTrain);

%% Fit
tic;
[ X, Y, T ] = GetAllData( xTrain, yTrain, TaskNum );
% kernel matrix
Q = Kernel(X, X, kernel);
P = sparse(0, 0);
for t = 1 : TaskNum
    Tt = T==t;
    P = blkdiag(P, Q(Tt,Tt));
end
G = Q + lambda/TaskNum*P;
% hessian matrix $x^\top Hx$
e = speye(size(Y));
D = sparse(diag(Y));
DG = D*G;
GD = DG';
DGD = DG*D;
H = [DGD,-DG,DG;-GD,G,-G;GD,-G,G];
% $f^\top x$
f = [-e;R*e;R*e];
Aeq = [Y;-e;e]';
beq = 0;
lb = zeros(size(f));
ub = [c*size(Y);Inf(size(Y));Inf(size(Y))];
% solve quadratic programming
Lambda = quadprog(H,f,[],[],Aeq,beq,lb,ub,[],solver);
Lambda = reshape(Lambda, length(Y), 2);
Alpha = Lambda(:,1);
Beta = Lambda(:,2);
Gamma = Lambda(:,3);
Theta = D*Alpha-Beta+Gamma;
% TODO: calculate b, d_t.
Time = toc;

%% Predict
yTest = cell(TaskNum, 1);
for t = 1 : TaskNum
    Tt = T == t;
    Ht = Kernel(xTest{t}, X, kernel);
    y = sign(Ht*Theta + TaskNum/lambda*Ht(:,Tt)*Theta(Tt,1));
    y(y==0) = 1;
    yTest{t} = y;
end

end

