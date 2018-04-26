function [ yTest, Time ] = PSVR( xTrain, yTrain, xTest, opts )
%PSVR 此处显示有关此函数的摘要
% Proximal Support Vector Regression
%   此处显示详细说明

%% Parse opts
nu = opts.nu;
kernel = opts.kernel;

%% Fit
tic;
X = xTrain;
Y = yTrain;
A = Kernel(X, X, kernel);
e = ones(size(Y));
H = A*A^T + 1;
I = speye(size(H));
Alpha = Cond(H + 1/nu*I)\Y;

%% Get w,b
w = A'*Alpha;
b = e'*Alpha;
Time = toc;

%% Predict
yTest = Kernel(xTest, X, kernel)*w+b;

end
