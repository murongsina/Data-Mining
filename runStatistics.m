Src = './data/classify/rbf/';
Dst = './lab/classify/rbf/';

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% 加载数据集和网格搜索参数
load('MTL_Caltech101.mat');
load('LabCParams.mat');

% 实验设置
opts = InitOptions('clf', 0, []);
MyStat = MyStatistics(MTL_Caltech101, CParams, Src, Dst, opts);
save('MyStat-MTL_Caltech101.mat', 'MyStat');