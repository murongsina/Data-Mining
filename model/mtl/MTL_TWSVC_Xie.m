function [ yTest, Time ] = MTL_TWSVC_Xie( xTrain, yTrain, xTest, opts )
%MTL_TWSVC_XIE 此处显示有关此函数的摘要
%   此处显示详细说明


%% Prepare
    tic;
    % 得到所有的样本和标签以及任务编号
    [ TaskNum, ~ ] = size(xTrain);  
    A = []; Y = []; T = [];
    for t = 1 : TaskNum
        % 得到任务i的H矩阵
        Xt = xTrain{t};
        A = cat(1, A, Xt);
        % 得到任务i的Y矩阵
        Yt = yTrain{t};
        Y = cat(1, Y, Yt);
        % 分配任务下标
        [m, ~] = size(Yt);
        Tt = t*ones(m, 1);
        T = cat(1, T, Tt);
    end
    [m, ~] = size(A);
    e = ones(m, 1);
    C = A; % 保留核变换矩阵
    A = [Kernel(A, C, kernel) e]; % 非线性变换

end

