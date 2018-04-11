Path = './data/';

% 添加搜索路径
addpath(genpath('./model'));
addpath(genpath('./utils'));
addpath(genpath('./utils/params/'));

% 加载数据集和网格搜索参数
load('LabSVMReg.mat');
load('LabUCIReg.mat');
load('LabMulti.mat');
load('LabIParams.mat');

% 实验数据集
LabDataSets = {LabSVMReg, LabUCIReg, LabMulti};
% 统计每个数据集上的多任务实验数据
m = length(LabDataSets);
for i = 1 : m
    DataSets = LabDataSets{i};
    n = length(DataSets);
    for j = 1 : n
        DataSet = DataSets(j);
        [ LabStat, HasStat ] = LabStatistics(Path, DataSet, IParams);
        if HasStat == 1
            FileName = ['LabStat-', DataSet.Name];
            StatPath = ['./statistics/', FileName, '.mat'];
            fprintf('save: %s\n', StatPath);
            save(StatPath, 'LabStat');
            bar(LabStat(:,:,1), 'DisplayName', FileName);
            savefig(['./figures/', FileName, '.fig']);
        end
    end
end