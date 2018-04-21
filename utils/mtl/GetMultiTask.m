function [ X, Y, ValInd ] = GetMultiTask( DataSet )
%GETMULTITASK 此处显示有关此函数的摘要
% 得到多任务交叉验证数据集
%   此处显示详细说明

    X = DataSet.X;
    Y = DataSet.Y;
    ValInd = DataSet.ValInd;
end