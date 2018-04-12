function [ OStat ] = CrossValid( Learner, X, Y, TaskNum, Kfold, ValInd, Params )
%CROSSVALID 此处显示有关此函数的摘要
% Cross Validation
%   此处显示详细说明

    % 多任务交叉验证统计
    CVStat = zeros(Kfold, 4, TaskNum);
    % 交叉验证
    for j = 1 : Kfold
        fprintf('CrossValid: %d\n', j);
        % 分割训练集和测试集
        [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, TaskNum, j, ValInd);
        % 在一组任务上训练和预测
        [ y ] = Learner(xTrain, yTrain, xTest, Params);
        % 统计多任务学习数据
        CVStat(j,:,:) = MTLStatistics(TaskNum, y, yTest);
    end
    
    % 统计多任务交叉验证结果
    OStat = CVStatistics(CVStat);

end
