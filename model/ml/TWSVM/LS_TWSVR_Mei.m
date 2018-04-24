function [ yTest, Time ] = LS_TWSVR_Mei(xTrain, yTrain, xTest, opts)
%LS_TWSVR 此处显示有关此函数的摘要
% Least Square Twin Support Vector Regression
% Derived from TWSVR via TWSVM
%   此处显示详细说明

%% Parse opts
C1 = opts.C1;
C2 = opts.C1;
eps1 = opts.eps1;
eps2 = opts.eps1;
kernel = opts.kernel;

%% Prepare
tic;
A = xTrain;
Y = yTrain;
[m, ~] = size(A);
e = ones(m, 1);
C = A;
A = [Kernel(A, C, kernel) e];
% 得到f和g
f = Y + eps2;
g = Y - eps1;
% 得到Q矩阵
AAA = Cond(A'*A)\A';
H = A*AAA;

%% Fit
I = speye(size(H));
Alpha = Cond(H - 1/C1*I)\(g - H*f);
Gamma = Cond(1/C2*I - H)\(f - H*g);
% 得到u,v
u = AAA*(f+Alpha);
v = AAA*(g-Gamma);
% 得到w
w = (u+v)/2;
% 停止计时
Time = toc;

%% Predict
[m, ~] = size(xTest);
e = ones(m, 1);
yTest = [Kernel(xTest, C, kernel), e]*w;

end
