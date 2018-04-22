function [  ] = SaveStatistics( Path, DataSet, LabStat, LabTime, opts )
%SAVESTATISTICS 此处显示有关此函数的摘要
% 保存统计数据
%   此处显示详细说明

    % 保存统计数据
    StatPath = [Path, '/statistics/LabStat-', DataSet.Name, '.mat'];
    save(StatPath, 'LabStat', 'LabTime');
    fprintf('save: %s\n', StatPath);
    
    % 保存图表
    SaveFigures(Path, DataSet, LabStat, LabTime, opts );
end