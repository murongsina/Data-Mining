function [ OStat ]  = MTLStatistics(TaskNum, y, yTest, opts)
%MTLSTATISTICS 此处显示有关此函数的摘要
% 多任务统计数据
%   此处显示详细说明

    Statistics = opts.Statistics;
    OStat = zeros(opts.IndexCount, TaskNum);
    for t = 1 : TaskNum
        OStat(:, t) = Statistics(y{t}, yTest{t});
    end
end