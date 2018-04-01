function [ TX, TY, TK ] = MultiTask( DataSet, TaskNum, Kfold )
%MULTITASK 此处显示有关此函数的摘要
% 转换多任务数据集，构造一组任务
%   此处显示详细说明

    TX = cell(TaskNum, 1);
    TY = cell(TaskNum, 1);
    TK = cell(TaskNum, 1);
    [X, Y] = SplitDataLabel(DataSet.Data, DataSet.Output);
    % 使用交叉验证，构造多任务数据集
    idx = crossvalind('Kfold', DataSet.Instances, TaskNum);
    for t = 1 : TaskNum
        TX{t} = X(idx==t,:);
        TY{t} = Y(idx==t,:);
        N = sum(idx==t);
        TK{t} = crossvalind('Kfold', N, Kfold);
    end
end