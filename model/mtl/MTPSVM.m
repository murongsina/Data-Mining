function [ yTest, Time ] = MTPSVM( xTrain, yTrain, xTest, opts )
%MTPSVM 此处显示有关此函数的摘要
% Multi-task proximal support vector machine
% ref:Multi-task proximal support vector machine
%   此处显示详细说明

%% Parse opts
TaskNum = length(xTrain);
lambda = opts.lambda;
nu = opts.nu;
kernel = opts.kernel;

%% Fit
tic;
[ X, Y, T ] = GetAllData( xTrain, yTrain, TaskNum );
H = Kernel(X, X, kernel);
Q = Y.*H.*Y';
P = sparse(0, 0);
for t = 1 : TaskNum
    Tt = T==t;
    y = Y(Tt,:);
    P = blkdiag(P, y.*(H(Tt,Tt) + 1).*y');
end
I = speye(size(Q));
E = ones(size(Y));
Alpha = Cond(Q + TaskNum/lambda*P + 1/nu*I)\E;
Time = toc;

%% Predict
TaskNum = length(xTest);
yTest = cell(TaskNum, 1);
for t = 1 : TaskNum
    Tt = T==t;
    Ht = Kernel(xTest{t}, X, kernel);
    y0 = Predict(Ht, Y, Alpha);
    yt = Predict(Ht(:,Tt), Y(Tt,:), Alpha(Tt,:));
    bt = TaskNum/lambda*Y(Tt,:)'*Alpha(Tt,:);
    y = sign(y0 + TaskNum/lambda * yt + bt);
    y(y==0) = 1;
    yTest{t} = y;
end

    function [ y ] = Predict(H, Y, Alpha)
        svi = Alpha~=0;
        y = H(:,svi)*(Y(svi,:).*Alpha(svi,:));
    end
end