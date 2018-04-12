function [ A, Y, T ] = GetAllData( xTrain, yTrain, TaskNum )
%GETALLDATA 此处显示有关此函数的摘要
%   此处显示详细说明

    A = cell2mat(xTrain);
    Y = cell2mat(yTrain);
    T = [];
    for t = 1 : TaskNum
        [m, ~] = size(yTrain{t});
        Tt = t*ones(m, 1);
        T = cat(1, T, Tt);
    end
end
