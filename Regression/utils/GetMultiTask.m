function [ X, Y, ValInd ] = GetMultiTask( DataSet )
%GETMULTITASK 此处显示有关此函数的摘要
% 得到多任务交叉验证数据集
%   此处显示详细说明

    TaskNum = DataSet.TaskNum;
    Task = DataSet.Task;
    X = cell(TaskNum, 1);
    Y = cell(TaskNum, 1);
    ValInd = cell(TaskNum, 1);
    [ Xd, Yd ] = SplitDataLabel(DataSet.Data, DataSet.Output);
    for t = 1 : TaskNum
        T = Task==t;
        X{t} = Xd(T,:);
        Y{t} = Yd(T,:);
        ValInd{t} = DataSet.ValInd(T,:);
    end
end

