Root = cd;
Path = [ Root '/data/regression/'];

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% 加载数据集和网格搜索参数
load('LabMTLReg.mat');
load('LabRParams.mat');
IParams = RParams;

% 实验数据集
LabDataSets = {LabMTLReg};

% 实验设置
opts = InitOptions('reg', []);

% 统计每个数据集上的多任务实验数据
m = length(LabDataSets);
for i = 1 : m
    DataSets = LabDataSets{i};
    n = length(DataSets);
    for j = 1 : n
        DataSet = DataSets(j);
        try
            [ LabStat, LabTime, HasStat ] = LabStatistics(Path, DataSet, IParams, 1, opts);
            if HasStat == 1
               SaveStatistics(Root, DataSet, LabStat, LabTime, opts);
            end
        catch MException
            fprintf(['Exception in: ', DataSet.Name, '\n']);
        end
    end
end