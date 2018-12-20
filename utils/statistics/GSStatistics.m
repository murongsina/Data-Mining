function [ OStat, OTime ] = GSStatistics(TaskNum, IStat, ITime, opts)
%GSSTATISTICS 此处显示有关此函数的摘要
% 多任务网格搜索统计
%   此处显示详细说明

    % 回归分类性能
    OStat = zeros(opts.IndexCount, TaskNum, 2);
    % 找平均准确率最高的一组
    MStat = mean(IStat, 3);
    [ ~, I ] = opts.Find(MStat(:,1));
    % 取多任务平均值
    if opts.Mean
        OStat(:,:,1) = mean(IStat(I,:,:), 3);
        OStat(:,:,2) = I;
    else
        OStat(:,:,1) = IStat(I(1),:,:);
        OStat(:,:,2) = I;
    end
    % 时间性能
    OStat = permute(OStat, [2 1 3]);
    OTime = mean(ITime);
end