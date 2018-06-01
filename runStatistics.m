Src = './data/classify/linear/';
Dst = './lab/classify/linear/';

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% 加载数据集和网格搜索参数
load('MTL_CIFAR.mat');
load('LabCParams-Linear.mat');

% 实验设置
opts = InitOptions('clf', 0, []);
MyStatistics(MTL_CIFAR, CParams, Src, Dst, opts);