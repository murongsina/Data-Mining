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
C = X;
Z = Kernel(X, C, kernel);
e = ones(size(Y));
alpha = Cond(Z*Z'+1+1/nu*speye(size(Z)))\Y;
w = Z'*alpha;
xi = alpha/nu;
gamma = -e'*alpha;
Time = toc;

%% Predict
yTest = Kernel(xTest, C, kernel)*w-gamma;

end
