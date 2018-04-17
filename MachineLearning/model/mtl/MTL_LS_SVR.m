function  [ yTest, Time, W ] = MTL_LS_SVR(xTrain, yTrain, xTest, opts)
%MTL_LS_SVR 此处显示有关此函数的摘要
% Multi-task least-squares support vector machines
%   此处显示详细说明

%% Parse opts
    lambda = opts.lambda;
    gamma = opts.gamma;
    kernel = opts.kernel;
    TaskNum = length(xTrain);
    
%% Prepare
    tic;
    % 得到所有的样本和标签以及任务编号
    [ A, Y, T ] = GetAllData( xTrain, yTrain, TaskNum );
    C = A; % 保留核变换矩阵
    A = Kernel(A, C, kernel); % 非线性变换
    
%% Fit
    B = [];
    E = [];
    for t = 1 : TaskNum
        Tt = T==t;
        At = A(Tt,:);
        B = blkdiag(B, At*At');
        E = blkdiag(E, ones(sum(Tt),1));
    end
    o = zeros(TaskNum, 1);
    O = diag(o);
    I = diag(ones(size(Y)));
    H = A*A' + 1/gamma*I + TaskNum/lambda*B;
    X = [O E';E H]\[o; Y];
    D = X(1:TaskNum,:);
    Alpha = X(TaskNum+1:end,:);
    
%% Get W
    W0 = A'*Alpha;
    W = cell(TaskNum, 1);
    for t = 1 : TaskNum
        Tt = T==t;
        W{t} = W0 + (TaskNum/lambda)*A(Tt,:)'*Alpha(Tt,:);
    end
    Time = toc;
    
%% Predict
    [ TaskNum, ~ ] = size(xTest);
    yTest = cell(TaskNum, 1);
    for t = 1 : TaskNum
        KAt = Kernel(xTest{t}, C, kernel);
        yTest{t} = KAt * W{t} + D(t);
    end
    
end
