function [ OStat ] = GSStatistics(TaskNum, IStat)
%GSSTATISTICS 此处显示有关此函数的摘要
% 多任务网格搜索统计
%   此处显示详细说明

    OStat = zeros(4, TaskNum, 2);
    [ MIN, IDX ] = min(IStat);
    OStat(:,:,1) = MIN(1,:,:);
    OStat(:,:,2) = IDX(1,:,:);
    OStat = permute(OStat, [2 1 3]);
end
