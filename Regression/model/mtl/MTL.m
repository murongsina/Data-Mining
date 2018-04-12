function [ yTest, Time, W ] = MTL(xTrain, yTrain, xTest, opts)
%MTL 此处显示有关此类的摘要
% Multi-Task Learning
%   此处显示详细说明

    Names = {
        'SVR', 'PSVR', 'TWSVR', 'TWSVR_Xu', 'LS_TWSVR'...
        'MTL_LS_SVR', 'MTL_PSVR', 'MTL_TWSVR', 'MTL_TWSVR_Xu', 'MTL_TWSVR_Mei'
    };
    Learners = {
        @SVR, @PSVR, @TWSVR, @TWSVR_Xu, @LS_TWSVR...
        @MTL_LS_SVR, @MTL_PSVR, @MTL_TWSVR, @MTL_TWSVR_Xu, @MTL_TWSVR_Mei
    };
    IsMTL = [ 0 0 0 0 0 1 1 1 1 1 ];
    
%% Parse opts
    str2func(opts.Name);
    N = length(Learners);
    for i = 1 : N
        if strcmp(Names{i}, opts.Name)
            if IsMTL(i)
                % 设置学习器
                Learner = Learners{i};
            else
                % 设置多任务的学习器
                BaseLearner = Learners{i};
                Learner = @MTLearner;
            end
        end
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