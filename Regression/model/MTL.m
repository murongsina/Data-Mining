function [ yTest, Time ] = MTL(xTrain, yTrain, xTest, opts)
%MTL 此处显示有关此类的摘要
% Multi-Task Learning
%   此处显示详细说明

    Names = { 'SVR', 'PSVR', 'TWSVR', 'MTL_PSVR', 'MTL_TWSVR' };
    Learners = { @SVR, @PSVR, @TWSVR, @MTL_PSVR, @MTL_TWSVR };
    IsMTL = [ 0 0 0 1 1 ];
    
%% Parse opts
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
    
    [ yTest, Time ] = Learner(xTrain, yTrain, xTest, opts);

%% Multi-Task Learner
    function [ yTest, Time ] = MTLearner(xTrain, yTrain, xTest, opts)
        [ TaskNum, ~ ] = size(xTrain);
        yTest = cell(TaskNum, 1);
        Times = zeros(TaskNum, 1);
        % 使用同样的学习器训练预测每一个任务
        for t = 1 : TaskNum
            [ y, time ] = BaseLearner(xTrain{t}, yTrain{t}, xTest{t}, opts);
            yTest{t} = y;
            Times(t) = time;
        end
        Time = sum(Times);
    end
    
end