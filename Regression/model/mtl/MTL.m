function [ yTest, Time, W ] = MTL(xTrain, yTrain, xTest, opts)
%MTL 此处显示有关此类的摘要
% Multi-Task Learning
%   此处显示详细说明

%% Multi Task Flag
    persistent IsMTL;
    if isempty(IsMTL)
        IsMTL = struct('SVR', 0, 'LS_SVR', 0, 'PSVR', 0,...
            'TWSVR', 0, 'TWSVR_Xu', 0, 'LS_TWSVR', 0,...
            'MTL_LS_SVR', 1, 'MTL_PSVR', 1,...
            'MTL_TWSVR', 1, 'MTL_TWSVR_Xu', 1,...
            'MTL_TWSVR_New', 1, 'MTL_TWSVR_Mei', 1);
    end
    
%% Parse opts
    Name = opts.Name;
    % 多任务
    if IsMTL.(Name) == 0
        BaseLearner = str2func(Name);
        Learner = @MTLearner;
    else
        Learner = str2func(Name);
    end
    
    [ yTest, Time, W ] = Learner(xTrain, yTrain, xTest, opts);

%% Multi-Task Learner
    function [ yTest, Time, W ] = MTLearner(xTrain, yTrain, xTest, opts)
        [ TaskNum, ~ ] = size(xTrain);
        yTest = cell(TaskNum, 1);
        Times = zeros(TaskNum, 1);
        W = cell(TaskNum, 1);
        % 使用同样的学习器训练预测每一个任务
        for t = 1 : TaskNum
            [ y, time, w ] = BaseLearner(xTrain{t}, yTrain{t}, xTest{t}, opts);
            yTest{t} = y;
            Times(t) = time;
            W{t} = w;
        end
        Time = sum(Times);
    end
    
end