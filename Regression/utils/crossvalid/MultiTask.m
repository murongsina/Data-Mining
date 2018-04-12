function [ DataSet ] = MultiTask( DataSet, TaskNum, Kfold )
%MULTITASK 此处显示有关此函数的摘要
% 转换多任务数据集，构造一组任务
%   此处显示详细说明

    [m, n] = size(DataSet.Data);
    DataSet.Instances = m;
    DataSet.Attributes = n-1;
    DataSet.Output = n;
    % 得到数据集基本信息
    Task = crossvalind('Kfold', DataSet.Instances, TaskNum);
    ValInd = zeros(DataSet.Instances, 1);
    for t = 1 : TaskNum
        TaskT = Task==t;
        ValInd(TaskT) = crossvalind('Kfold', sum(TaskT), Kfold);
    end
    DataSet.Task = Task;
    DataSet.TaskNum = TaskNum;
    DataSet.Kfold = Kfold;
    DataSet.ValInd = ValInd;
end