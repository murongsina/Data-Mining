function  [ yTest, Time, W ] = MTL_LS_SVM(xTrain, yTrain, xTest, opts)
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
        Zt = Z(Tt,:);
        B = blkdiag(B, Zt*Zt');
        A = blkdiag(A, Y(Tt,:));
    end
    o = zeros(TaskNum, 1);
    O = diag(o);
    I = diag(ones(size(Y)));
    H = Z*Z' + 1/gamma*I + TaskNum/lambda*B;
    E = ones(size(Y));
    bAlpha = [O A';A H]\[o; E];
    D = bAlpha(1:TaskNum,:);
    Alpha = bAlpha(TaskNum+1:end,:);
    
%% Get W
    W0 = Z'*Alpha;
    W = cell(TaskNum, 1);
    for t = 1 : TaskNum
        Tt = T==t;
        W{t} = W0 + (TaskNum/lambda)*Z(Tt,:)'*Alpha(Tt,:);
    end
    Time = toc;
    
%% Predict
    [ TaskNum, ~ ] = size(xTest);
    yTest = cell(TaskNum, 1);
    for t = 1 : TaskNum
        KAt = Kernel(xTest{t}, C, kernel);
        yt = sign(KAt * W{t} + D(t));
        yt(yt==0) = 1;
        yTest{t} = yt;
    end
    
end
