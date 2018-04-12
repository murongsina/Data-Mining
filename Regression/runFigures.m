Path = cd;

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

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
        StatPath = [Path, './statistics/LabStat-', DataSet.Name, '.mat'];
        if exist(StatPath, 'file') == 2
            load(StatPath);
            SaveFigures(Path, DataSet, LabStat);
        end
    end
end