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
H = Kernel(X, X, kernel);
I = speye(size(H));
Alpha = Cond(H + 1 + 1/nu*I)\Y;
svi = (Alpha>0)&(Alpha<nu);
b = sum(Alpha(svi));
Time = toc;

%% Predict
yTest = Kernel(xTest, X(svi,:), kernel)*Alpha(svi,:)+b;

end