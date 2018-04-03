function [ Stat ] = GridSearchCV( Learner, X, Y, IParams, TaskNum, Kfold, ValInd, opts )
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

    solver = opts.solver;
    nParams = length(IParams);
    CVStat = zeros(nParams, 4, TaskNum);
    % 网格搜索
    for idx = 1 : nParams
        fprintf('GridSearchCV: %d', idx);
        % 设置参数
        Params = IParams(idx);
        Params.solver = solver;
        % 交叉验证
        CVStat(idx,:,:) = CrossValid(Learner, X, Y, TaskNum, Kfold, ValInd, Params);
    end
    Stat = CVStatistics(TaskNum, CVStat);
    
%% Cross Validation    
    function [ OStat ] = CrossValid(Learner, X, Y, TaskNum, Kfold, ValInd, Params)
        % 多任务交叉验证统计
        MTLStat = zeros(Kfold, 4, TaskNum);
        % 交叉验证
        for j = 1 : Kfold
            fprintf('CrossValid: %d', j);
            % 分割训练集和测试集
            [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, TaskNum, j, ValInd);
            % 在一组任务上训练和预测
            [ y, ~ ] = Learner(xTrain, yTrain, xTest, Params);
            % 统计多任务学习数据
            MTLStat(j,:,:) = TaskStatistics(TaskNum, y, yTest);
        end
        % 统计多任务交叉验证结果
        OStat = MTLStatistics(TaskNum, MTLStat);
    end

%% Multi-Task GridSearchCV Statistics
    function [ xTrain, yTrain, xTest, yTest ] = TrainTest(X, Y, Kfold, ValInd)
        test = ValInd==Kfold;
        train = ~test;
        xTrain = X(train,:);
        yTrain = Y(train,:);
        xTest = X(test,:);
        yTest = Y(test,:);
    end

    function [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, TaskNum, Kfold, ValInd)
        xTrain = cell(TaskNum, 1);
        yTrain = cell(TaskNum, 1);
        xTest = cell(TaskNum, 1);
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            [ xTrain{t}, yTrain{t}, xTest{t}, yTest{t} ] = TrainTest(X{t}, Y{t}, Kfold, ValInd{t});
        end
    end

    function [ OStat ]  = TaskStatistics(TaskNum, y, yTest)
        % 统计指标
        Funcs = {@mae, @mse, @sae, @sse};
        OStat = zeros(4, TaskNum);
        for t = 1 : TaskNum
            for k = 1 : 4
                Func = Funcs{k};
                OStat(k, t) = Func(y{t}-yTest{t});%, y{t}, yTest{t});
            end
        end
    end

    function [ OStat ] = MTLStatistics(TaskNum, IStat)
        % 多任务统计
        OStat = zeros(4, TaskNum);
        for t = 1 : TaskNum
            % 得到K折平均值
            OStat(:, t) = mean(IStat(:,:,t));
        end
    end

    function [ OStat ] = CVStatistics(TaskNum, IStat)
        % 交叉验证统计
        OStat = zeros(4, 2, TaskNum);
        for t = 1 : TaskNum
            for k = 1 : 4
                 OStat(k,:,t) = max(IStat(:,k,t));                 
            end
        end
    end
end