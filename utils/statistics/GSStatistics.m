function [ OStat, OTime ] = GSStatistics(TaskNum, IStat, ITime, opts)
%GSSTATISTICS 此处显示有关此函数的摘要
% 多任务网格搜索统计
%   此处显示详细说明

    % 回归性能
    OStat = zeros(2*opts.IndexCount, TaskNum, 2);
    [ MIN, IDX ] = max(IStat);
    OStat(:,:,1) = MIN(1,:,:);
    OStat(:,:,2) = IDX(1,:,:);
    OStat = permute(OStat, [2 1 3]);
    % 时间性能
    [ MIN, IDX ] = min(ITime);
    OTime = [MIN; IDX];
end
