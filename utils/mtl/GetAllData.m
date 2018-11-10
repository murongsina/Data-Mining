function [ A, Y, T, N ] = GetAllData( xTrain, yTrain, TaskNum )
%GETALLDATA 此处显示有关此函数的摘要
%   此处显示详细说明

    A = cell2mat(xTrain);
    Y = cell2mat(yTrain);
    T = [];
    N = zeros(2, TaskNum);
    for t = 1 : TaskNum
        [m, ~] = size(yTrain{t});
        Tt = t*ones(m, 1);
        T = cat(1, T, Tt);
        N(1, t) = sum(yTrain{t}==1);
        N(2, t) = sum(yTrain{t}==-1);
    end
end
