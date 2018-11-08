function [ yTest, Time ] = ITWSVM( xTrain, yTrain, xTest, opts)
%ITWSVM 此处显示有关此函数的摘要
%   此处显示详细说明

%% Parse opts
C1 = opts.C1;
C2 = opts.C1;
C3 = opts.C3;
C4 = opts.C3;
kernel = opts.kernel;
solver = opts.solver;
symmetric = @(H) (H+H')/2;

%% Fit
% 计时
tic
% 分割正负类点
A = xTrain(yTrain==1, :);
B = xTrain(yTrain==-1, :);
[m1, ~] = size(A);
[m2, ~] = size(B);
n = m1 + m2;
e1 = ones(m1, 1);
e2 = ones(m2, 1);
% 构造核矩阵
C = [A; B];
A = [Kernel(A, C, kernel) e1];
B = [Kernel(B, C, kernel) e2];
AA = A*A';
AB = A*B';
BB = B*B';
% DITWSVM1
Ip = speye(size(AA));
Q1 = [AA+C3*Ip AB; AB BB];
lb1 = [-Inf(m1,1); zeros(m2, 1)];
ub1 = [Inf(m1,1); C1*e2];
Alpha = quadprog(symmetric(Q1),-C3*[0*e1 e2]',[],[],[],[],lb1,ub1,[],solver);
w1 = -(A'*Alpha(1:m1)+B'*Alpha(m1+1:end))/C3;
b1 = -(e1'*Alpha(1:m1)+e2'*Alpha(m1+1:end))/C3;
% DITWSVM2
In = speye(size(BB));
Q2 = [BB+C4*In AB'; AB' AA];
lb2 = [-Inf(m2,1); zeros(m1, 1)];
ub2 = [Inf(m2,1); C2*e1];
Beta = quadprog(symmetric(Q2),-C4*[0*e2 e1]',[],[],[],[],lb2,ub2,[],solver);
w2 = -(B'*Beta(1:m2)-A'*Beta(m2+1:end))/C4;
b2 = -(e2'*Beta(1:m2)-e1'*Beta(m2+1:end))/C4;
% 停止计时
Time = toc;

%% Predict
K = Kernel(xTest, C, kernel);
D1 = abs(K*w1+b1)/norm(w1);
D2 = abs(K*w2+b2)/norm(w2);
yTest = sign(D2-D1);
yTest(yTest==0) = 1;

end

