function [ yTest, Time ] = LS_SVR(xTrain, yTrain, xTest, opts)
%LS_SVR 此处显示有关此函数的摘要
% Least Square Support Vector Regression
%   此处显示详细说明

%% Parse opts
gamma = opts.gamma;
kernel = opts.kernel;

%% Fit
tic;
X = xTrain;
Y = yTrain;
Q = Kernel(X, X, kernel);
I = speye(size(Q));
H = Q + 1/gamma*I;
E = ones(size(Y));
Alphab = [H E;E' 0]\[Y; 0];
Alpha = Alphab(1:end-1);
svi = (Alpha>0)&(Alpha<gamma);
b = Alphab(end);
Time = toc;

%% Predict
yTest = Kernel(xTest, X(svi,:), kernel)*Alpha(svi,:)+b;

end