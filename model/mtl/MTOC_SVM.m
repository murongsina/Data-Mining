function [ yTest, Time ] = MTOC_SVM( xTrain, yTrain, xTest, opts )
%MTOC_SVM 此处显示有关此函数的摘要
% Multi-Task Learning for One-Class SVM with Additional New Features
%   此处显示详细说明

%% Parse opts
mu = opts.mu;
C = opts.C;
kernel = opts.kernel;
solver = opts.solver;
TaskNum = length(xTrain);

%% Fit
tic;
[ X, Y, T ] = GetAllData( xTrain, yTrain, TaskNum );
Ip = find(Y==1);
Xp = X(Ip,:);
Q = Kernel(Xp, Xp, kernel);
P = sparse(0, 0);
for t = 1 : TaskNum
    Tt = T(Ip,1)==t;
    P = blkdiag(P, Q(Tt,Tt));
end
H = mu*Q+(1-mu)*P;
e = ones(size(Ip));
lb = zeros(size(Ip));
ub = C*e;
Alpha = quadprog(H,e',[],[],[],[],lb,ub,[],solver);
Time = toc;

%% Predict
TaskNum = length(xTest);
yTest = cell(TaskNum, 1);
for t = 1 : TaskNum
    Tt = T(Ip,1)==t;
    Ht = Kernel(xTest{t}, Xp, kernel);
    y = sign(mu*Ht*Alpha+(1-mu)*Ht(:,Tt)*Alpha(Tt,1)-1);
    y(y==0) = 1;
    yTest{t} = y;
end

end