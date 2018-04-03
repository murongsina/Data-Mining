function [ Output ] = GridSearchCV( Learner, X, Y, IParams, opts )
%GRIDSEARCHCV 此处显示有关此函数的摘要
% 多任务的网格搜索交叉验证
%   此处显示详细说明
% 参数：
%    Learner    -学习器
%          X    -样本
%          Y    -标签
%     Params    -参数网格
%      Kfold    -K折交叉验证
% 输出：
%     Output    -网格搜索、交叉验证结果

    TaskNum = opts.TaskNum;
    Kfold = opts.Kfold;
    ValInd = opts.ValInd;

    nParams = length(IParams);
    Output = zeros(nParams, 5);
    for i = 1 : nParams
        fprintf('GridSearchCV: %d', i);
        TaskStat = zeros(Kfold, 4, TaskNum);
        Params = IParams(i);
        for j = 1 : Kfold
            fprintf('CrossValid: %d', kj);
            % 分割训练集和测试集
            [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, TaskNum, j, ValInd);
            % 在一组任务上训练和预测
            [ y, ~ ] = Learner(xTrain, yTrain, xTest, Params);
            % 统计多任务学习数据
            TaskStat(j,:,:) = Statistics(y, yTest, TaskNum);
        end
        Output(i,:) = MTLStatistics(TaskStat);
    end
    
%% Statistics
    function [ xTrain, yTrain, xTest, yTest ] = TrainTest(X, Y, ValInd, Kfold)
        test = ValInd==Kfold;
        train = ~test;
        xTrain = X(train,:);
        yTrain = Y(train,:);
        xTest = X(test,:);
        yTest = Y(test,:);
    end

    function [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, TaskNum, ValInd, Kfold)
        xTrain = cell(TaskNum, 1);
        yTrain = cell(TaskNum, 1);
        xTest = cell(TaskNum, 1);
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            [ xTrain{t}, yTrain{t}, xTest{t}, yTest{t} ] = TrainTest(X{t}, Y{t}, ValInd{t}, Kfold);
        end
    end

    function [ TaskStat ]  = Statistics(y, yTest, TaskNum)
        % 统计指标
        Funcs = {@mae, @mse, @sae, @sse};
        TaskStat = zeros(TaskNum, 4);
        for t = 1 : TaskNum
            for k = 1 : 4
                Func = Funcs{k};
                TaskStat(k, t) = Func(y{t}-yTest{t}, y{t}, yTest{t});
            end
        end
    end

    function [ OStat ] = MTLStatistics(TaskStat, TaskNum)
        % 多任务统计指标
        OStat = cell(TaskNum, 4);
        for t = 1 : TaskNum
            ITask = TaskStat(:,:,TaskNum);
            % 得到K折平均值
            OStat(t, :) = mean(ITask, 1);
        end
    end
end