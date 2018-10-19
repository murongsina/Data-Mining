function  [ yTest, Time ] = MTLS_SVM(xTrain, yTrain, xTest, opts)
%MTLS_SVM 此处显示有关此函数的摘要
% Multi-task least-squares support vector machines
% ref:Multi-task least-squares support vector machines
%   此处显示详细说明

%% Parse opts
lambda = opts.lambda;
gamma = opts.gamma;
kernel = opts.kernel;
TaskNum = length(xTrain);

%% Fit
tic;
[ X, Y, T ] = GetAllData( xTrain, yTrain, TaskNum );
Q = Y.*Kernel(X, X, kernel).*Y';
P = sparse(0, 0);
A = sparse(0, 0);
for t = 1 : TaskNum
    Tt = T==t;
    P = blkdiag(P, Q(Tt,Tt));
    A = blkdiag(A, Y(Tt,:));
end
o = zeros(TaskNum, 1);
O = speye(TaskNum)*0;
I = speye(size(Q));
E = ones(size(Y));
H = Q + TaskNum/lambda*P + 1/gamma*I;
bAlpha = [O A';A H]\[o; E];
b = bAlpha(1:TaskNum,:);
Alpha = bAlpha(TaskNum+1:end,:);
Time = toc;

%% Predict
TaskNum = length(xTest);
yTest = cell(TaskNum, 1);
for t = 1 : TaskNum
    Tt = T==t;
    Ht = Kernel(xTest{t}, X, kernel);
    y0 = Predict(Ht, Y, Alpha);
    yt = Predict(Ht(:,Tt), Y(Tt,:), Alpha(Tt,:));
    y = sign(y0 + TaskNum/lambda*yt + b(t));
    y(y==0) = 1;
    yTest{t} = y;
end

    function [ y ] = Predict(H, Y, Alpha)
        svi = Alpha~=0;
        y = H(:,svi)*(Y(svi).*Alpha(svi));
    end
end
