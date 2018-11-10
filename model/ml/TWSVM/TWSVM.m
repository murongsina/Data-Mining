function [ yTest, Time ] = TWSVM(xTrain, yTrain, xTest, opts)
%TWSVM 此处显示有关此类的摘要
% Twin Support Vector Machine
%   此处显示详细说明

%% Parse opts
C1 = opts.C1;
C2 = opts.C1;
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
S = [Kernel(A, C, kernel) e1];
R = [Kernel(B, C, kernel) e2];
S2R = Cond(S'*S)\R';
R2S = Cond(R'*R)\S';
% KDTWSVM1
Alpha = quadprog(symmetric(R*S2R),-e2,[],[],[],[],zeros(m2, 1),e2*C1,[],solver);
z1 = -S2R*Alpha;
u1 = z1(1:n);
b1 = z1(end);
% KDTWSVM2
Mu = quadprog(symmetric(S*R2S),-e1,[],[],[],[],zeros(m1, 1),e1*C2,[],solver);
z2 = R2S*Mu;
u2 = z2(1:n);
b2 = z2(end);
% 停止计时
Time = toc;

%% Predict
K = Kernel(xTest, C, kernel);
D1 = abs(K*u1+b1)/norm(u1);
D2 = abs(K*u2+b2)/norm(u2);
yTest = sign(D2-D1);
yTest(yTest==0) = 1;

end