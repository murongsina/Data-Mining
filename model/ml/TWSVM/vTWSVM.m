function [ yTest, Time ] = vTWSVM(xTrain, yTrain, xTest, opts)
%VTWSVM 此处显示有关此函数的摘要
% $\nu$-Twin Support Vector Machine
%   此处显示详细说明

%% Parse opts
v1 = opts.v1;
v2 = opts.v1;
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
H = [Kernel(A, C, kernel) e1];
G = [Kernel(B, C, kernel) e2];
H2G = Cond(H'*H)\G';
G2H = Cond(G'*G)\H';
% v-DTWSVM1
Alpha = quadprog(symmetric(G*H2G),[],-e2',-v1,[],[],zeros(m2, 1),e2/m2,[],solver);
z1 = -H2G*Alpha;
u1 = z1(1:n);
b1 = z1(end);
% v-DTWSVM2
Beta = quadprog(symmetric(H*G2H),[],-e1',-v2,[],[],zeros(m1, 1),e1/m1,[],solver);
z2 = G2H*Beta;
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

