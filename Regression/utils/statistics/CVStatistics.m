function [ OStat ] = CVStatistics(IStat)
%CVSTATISTICS 此处显示有关此函数的摘要
% 交叉验证多任务统计
%   此处显示详细说明

    % 平均值/标准差
    StatM = mean(IStat);
    StatS = std(IStat);
    OStat1 = permute(StatM, [2 3 1]);
    OStat2 = permute(StatS, [2 3 1]);
    OStat = [OStat1; OStat2];
end

