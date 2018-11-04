function [ yTest, Time ] = SVM(xTrain, yTrain, xTest, opts)
%CSVM 此处显示有关此类的摘要
% C-Support Vector Machine
%   此处显示详细说明

%% Parse opts
C = opts.C;            % 参数
kernel = opts.kernel;  % 核函数

%% Fit
tic
X = xTrain;
Y = yTrain;
% 二次规划求解
e = ones(size(Y));
K = Kernel(X, X, kernel);
I = speye(size(K));
DY = I.*Y;
H = Cond(DY*K*DY);
Alpha = quadprog(H, -e, Y', 0, [], [], 0*e, C*e, [], []);
svi = Alpha > 0;
b = mean(Y(svi,:)-K(svi,:)*(Y(svi,:).*Alpha(svi,:)));
% 停止计时
Time = toc;

%% Predict
yTest = sign(Kernel(xTest, X(svi,:), kernel)*(Y(svi,:).*Alpha(svi,:))+b);
yTest(yTest==0) = 1;

end