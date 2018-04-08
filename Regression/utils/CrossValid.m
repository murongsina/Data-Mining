function [ OStat ] = CrossValid( Learner, X, Y, TaskNum, Kfold, ValInd, Params )
%CROSSVALID 此处显示有关此函数的摘要
% Cross Validation
%   此处显示详细说明

    % 多任务交叉验证统计
    MTLStat = zeros(Kfold, 4, TaskNum);
    % 交叉验证
    for j = 1 : Kfold
        fprintf('CrossValid: %d\n', j);
        % 分割训练集和测试集
        [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, TaskNum, j, ValInd);
        % 在一组任务上训练和预测
        [ y, ~ ] = Learner(xTrain, yTrain, xTest, Params);
        % 统计多任务学习数据
        MTLStat(j,:,:) = TaskStatistics(TaskNum, y, yTest);
    end
    
    % 统计多任务交叉验证结果
    OStat = MTLStatistics(TaskNum, MTLStat);
        
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

    function [ MAE, RMSE, SSE, SSR, SST ] = Statistics(y, yTest)
        y_bar = mean(yTest);
        E = yTest-y;
        E2 = E.^2;
        MAE = mean(abs(E));
        RMSE = sqrt(mean(E2));
        SSE = sum(E2);
        SST = sum((yTest-y_bar).^2);
        SSR = sum((y-y_bar).^2);
    end

    function [ OStat ]  = TaskStatistics(TaskNum, y, yTest)
        % 统计数据
        OStat = zeros(4, TaskNum);
        for t = 1 : TaskNum
            [ MAE, RMSE, SSE, SSR, SST ] = Statistics(y{t}, yTest{t});
            OStat(:, t) = [ MAE, RMSE, SSE/SST, SSR/SSE ];
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
end
