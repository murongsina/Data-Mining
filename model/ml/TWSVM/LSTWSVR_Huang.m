function [ yTest, Time ] = LSTWSVR_Huang( xTrain, yTrain, xTest, opts )
%LS_TWSVR 此处显示有关此函数的摘要
% Primal least squares twin support vector regression
% $Hua-juan HUANG^1, Shi-fei DING^{??1,2}, Zhong-zhi SHI^{2}$
%   此处显示详细说明

%% Parse opts
eps1 = opts.eps1;
eps2 = opts.eps1;
kernel = opts.kernel;

%% Fit
tic;
A = xTrain;
Y = yTrain;
e = ones(size(Y));
G = [Kernel(A, A, kernel) e];
f = Y - eps1;
h = Y + eps2;
GGG = Cond(G'*G)\G';
% LS_TWSVR1
u1 = GGG*f;
% LS_TWSVR2
u2 = GGG*h;
w = (u1+u2)/2;
Time = toc;

%% Predict
[m, ~] = size(xTest);
yTest = [Kernel(xTest, A, kernel), ones(m, 1)]*w;

end

