function [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, TaskNum, Kfold, ValInd)
%MTLTRAINTEST 此处显示有关此函数的摘要
% 多任务训练测试集
%   此处显示详细说明

    xTrain = cell(TaskNum, 1);
    yTrain = cell(TaskNum, 1);
    xTest = cell(TaskNum, 1);
    yTest = cell(TaskNum, 1);
    for t = 1 : TaskNum
        [ xTrain{t}, yTrain{t}, xTest{t}, yTest{t} ] = TrainTest(X{t}, Y{t}, Kfold, ValInd{t});
    end
end
