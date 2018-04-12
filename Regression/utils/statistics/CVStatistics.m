function [ OStat ] = CVStatistics(IStat)
%CVSTATISTICS 此处显示有关此函数的摘要
% 交叉验证多任务统计
%   此处显示详细说明

    MStat = mean(IStat);
    OStat = permute(MStat, [2 3 1]);
end

