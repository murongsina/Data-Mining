Path = './data/';

% 添加搜索路径
addpath(genpath('./model'));
addpath(genpath('./utils'));
addpath(genpath('./utils/params/'));

% 加载数据集和网格搜索参数
load('LabUCIReg.mat');
load('LabMulti.mat');
load('LabIParams.mat');

% 实验数据集
LabDataSets = {LabUCIReg, LabMulti};
% 统计每个数据集上的多任务实验数据
index = 0;
for i = 1 : 2
    DataSets = LabDataSets{i};
    n = length(DataSets);
    for j = 1 : n
        index = index + 1;
        DataSet = DataSets(j);
        [ LabStat, HasStat ] = LabStatistics(Path, DataSet, IParams);
        if HasStat == 1
            FileName = ['LabStat-', DataSet.Name];
            StatPath = ['./statistics/', FileName, '.mat'];
            fprintf('save: %s\n', StatPath);
            save(StatPath, 'LabStat');
            bar(LabStat, 'DisplayName', FileName);
            savefig(['./figures/', FileName, '.fig']);
        end
    end
end