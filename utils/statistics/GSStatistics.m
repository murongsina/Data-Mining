function [ OStat, OTime ] = GSStatistics(TaskNum, IStat, ITime, opts)
%GSSTATISTICS 此处显示有关此函数的摘要
% 多任务网格搜索统计
%   此处显示详细说明

    % 回归性能
    OStat = zeros(2*opts.IndexCount, TaskNum, 2);
    [ Y, I ] = opts.Find(IStat);
    OStat(:,:,1) = Y(1,:,:);
    OStat(:,:,2) = I(1,:,:);
    OStat = permute(OStat, [2 1 3]);
    % 时间性能
    [ Y, I ] = min(ITime);
    OTime = [Y; I];
end