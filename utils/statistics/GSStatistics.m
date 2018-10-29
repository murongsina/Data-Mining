function [ OStat, OTime ] = GSStatistics(TaskNum, IStat, ITime, opts)
%GSSTATISTICS 此处显示有关此函数的摘要
% 多任务网格搜索统计
%   此处显示详细说明

    % 回归分类性能
    OStat = zeros(2*opts.IndexCount, TaskNum, 2);
    % 取多任务平均值
    if opts.Mean
        MStat = mean(IStat, 3);
        [ ~, I ] = opts.Find(MStat(:,1));
        OStat(:,:,1) = mean(IStat(I,:,:), 3);
        OStat(:,:,2) = I;
    else
        [ Y, I ] = opts.Find(IStat);
        OStat(:,:,1) = Y(1,:,:);
        OStat(:,:,2) = I(1,:,:);
    end
    % 时间性能
    OStat = permute(OStat, [2 1 3]);
    OTime = mean(ITime);
end