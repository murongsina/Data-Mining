Src = './data/classify/rbf/';
Dst = './lab/classify/rbf/';

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% 加载数据集和网格搜索参数
load('MTL_UCI.mat');
load('LabCParams.mat');

% 实验设置
opts = InitOptions('clf', 1, []);
[ MyStat, MyRank ] = MyStatistics(MTL_UCI([13 14 15 18:26]), CParams, Src, Dst, opts);
save('MyStat-Caltech.mat', 'MyStat', 'MyRank');