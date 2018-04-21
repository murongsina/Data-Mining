function [ Stat ] = ClfStat(y, yTest)
%CLFSTAT 此处显示有关此函数的摘要
%   此处显示详细说明

    Accuracy = mean(y==yTest);
    Stat = [ Accuracy ];
end

