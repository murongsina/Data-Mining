function [ xTrain, yTrain, xTest, yTest ] = TrainTest(X, Y, Kfold, ValInd)
%TRAINTEST 此处显示有关此函数的摘要
% 训练测试集
%   此处显示详细说明

    test = ValInd==Kfold;
    train = ~test;
    xTrain = X(train,:);
    yTrain = Y(train,:);
    xTest = X(test,:);
    yTest = Y(test,:);
end