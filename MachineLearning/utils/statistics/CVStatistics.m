function [ OStat, TStat ] = CVStatistics(IStat, ITime)
%CVSTATISTICS 此处显示有关此函数的摘要
% 多任务交叉验证统计
%   此处显示详细说明

    OStat1 = permute(mean(IStat), [2 3 1]);
    OStat2 = permute(std(IStat), [2 3 1]);
    OStat = [OStat1; OStat2];
    TStat = [mean(ITime) std(ITime)];
end

