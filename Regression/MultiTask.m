function [ TX, TY ] = MultiTask( DataSet, TaskNum )
%MULTITASK 此处显示有关此函数的摘要
% 转换多任务数据集，构造一组任务
%   此处显示详细说明

    TX = cell(TaskNum, 1);
    TY = cell(TaskNum, 1);
    [X, Y] = SplitDataLabel(DataSet.Data, DataSet.Output);
    [m, ~] = size(X);
    idx = crossvalind('Kfold', m, TaskNum);
    for t = 1 : TaskNum
        TX{t} = X(idx==t,:);
        TY{t} = Y(idx==t,:);
    end
end