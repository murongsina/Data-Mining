function [ LabStat, HasStat ] = LabStatistics(Path, DataSet, IParams)
%STATISTIC 此处显示有关此函数的摘要
% 统计单任务数据集
%   此处显示详细说明

    HasStat = 0;
    nParams = length(IParams);
    LabStat = zeros(nParams, DataSet.TaskNum, 8);
    for k = 1 : nParams
        Method = IParams{k};
        StatPath = [Path, './data/', DataSet.Name, '-', Method.Name, '.mat'];
        if exist(StatPath, 'file') == 2
            load(StatPath);
            LabStat(k,:,:) = Stat(:,:,1);
            HasStat = 1;
        end
    end
end