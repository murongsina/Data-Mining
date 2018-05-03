Src = './data/regression/linear/';
Dst = './lab/regression/linear/';

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% 加载数据集和网格搜索参数
load('LabMTLReg.mat');
load('LabRParams-Linear.mat');

% 实验设置
opts = InitOptions('reg', 1, []);
MyStatistics(LabMTLReg, RParams, Src, Dst, opts);