function [ OStat ]  = MTLStatistics(TaskNum, y, yTest, Time)
%MTLSTATISTICS 此处显示有关此函数的摘要
% 多任务统计数据
%   此处显示详细说明

    OStat = zeros(4, TaskNum);
    for t = 1 : TaskNum
        [ MAE, RMSE, SSET, SSRT ] = Statistics(y{t}, yTest{t});
        OStat(:, t) = [ MAE, RMSE, SSET, SSRT ];
    end
end
