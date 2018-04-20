function [ LabStat, LabTime, HasStat ] = LabStatistics(Path, DataSet, IParams, Mean)
%LABSTATISTIC 此处显示有关此函数的摘要
% 统计多任务实验数据
%   此处显示详细说明

    HasStat = 0;
    nParams = length(IParams);
    LabStat = zeros(nParams, DataSet.TaskNum, 8);
    LabTime = zeros(nParams, 2);
    for k = 1 : nParams
        Method = IParams{k};
        StatPath = [Path, './data/', DataSet.Name, '-', Method.Name, '.mat'];
        if exist(StatPath, 'file') == 2
            load(StatPath);
            [ ~, ~, n ] = size(CVStat);
            if n~= DataSet.TaskNum
                ME = MException('LabStatistics', 'TaskNum miss match in %s\n', Method.Name);
                throw(ME);
            else
                % 取多任务平均值
                if Mean
                    CVStat = mean(CVStat, 2);
                end
                % 网格搜索结果
                [ Stat, Time ] = GSStatistics(DataSet.TaskNum, CVStat, CVTime);
                % 保存数据
                LabStat(k,:,:) = Stat(:,:,1);
                LabTime(k,:) = Time(1,:);
                HasStat = 1;
            end
        end
    end
end