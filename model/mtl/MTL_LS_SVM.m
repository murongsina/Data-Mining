function  [ yTest, Time ] = MTL_LS_SVM(xTrain, yTrain, xTest, opts)
%MTL_LS_SVM 此处显示有关此函数的摘要
% Multi-task least-squares support vector machines
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
Z = Kernel(X, C, kernel);

%% Fit
B = [];
A = [];
for t = 1 : TaskNum
    Tt = T==t;
    B = blkdiag(B, Z(Tt,Tt));
    A = blkdiag(A, Y(Tt,:));
end
B = sparse(B);
A = sparse(A);
o = zeros(TaskNum, 1);
O = diag(o);
E = ones(size(Y));
I = speye(size(B));
H = Z + 1/gamma*I + TaskNum/lambda*B;
bAlpha = [O A';A H]\[o; E];
b = bAlpha(1:TaskNum,:);
Alpha = bAlpha(TaskNum+1:end,:);
Time = toc;

%% Predict
[ TaskNum, ~ ] = size(xTest);
yTest = cell(TaskNum, 1);
for t = 1 : TaskNum
    KA = Kernel(xTest{t}, C, kernel);
    KAt = KA(:,T==t);
    yt = sign(KA*Alpha + KAt*Alpha(T==t) + b(t));
    yt(yt==0) = 1;
    yTest{t} = yt;
end

end
