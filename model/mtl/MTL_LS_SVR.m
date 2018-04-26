function  [ yTest, Time ] = MTL_LS_SVR(xTrain, yTrain, xTest, opts)
%MTL_LS_SVR 此处显示有关此函数的摘要
% Multi-task least-squares support vector regression
% ref:Multi-task least-squares support vector machines
%   此处显示详细说明

%% Parse opts
lambda = opts.lambda;
gamma = opts.gamma;
kernel = opts.kernel;
TaskNum = length(xTrain);

%% Prepare
tic;
[ X, Y, T ] = GetAllData( xTrain, yTrain, TaskNum );
C = X;
Omiga = Kernel(X, C, kernel);

%% Fit
B = sparse(0, 0);
A = sparse(0, 0);
for t = 1 : TaskNum
    Tt = T==t;
    Kt = Omiga(Tt,Tt);
    B = blkdiag(B, Kt);
    A = blkdiag(A, ones(sum(Tt),1));
end

o = ones(TaskNum,1);
O = speye(TaskNum)*0;
I = speye(size(Omiga));

H = Omiga + 1/gamma*I + TaskNum/lambda*B;
bAlpha = [O A';A H]\[o; Y];
b = bAlpha(1:TaskNum,:);

Alpha = bAlpha(TaskNum+1:end,:);

Time = toc;

%% Predict
TaskNum = length(xTest);
yTest = cell(TaskNum, 1);
for t = 1 : TaskNum
    H = Kernel(xTest{t}, C, kernel);
    yTest{t} = H*Alpha + H(:,T==t)*Alpha(T==t,:) + b(t);
end

end
