Src = './data/regression/rbf/';
Dst = './lab/regression/rbf/';

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% 加载数据集和网格搜索参数
load('LabMTLReg.mat');
load('LabRParams.mat');

% 实验设置
opts = InitOptions('reg', 1, []);
[ MyStat, MyRank ] = MyStatistics(LabMTLReg, RParams, Src, Dst, opts);
save('MyStat-LabMTLReg.mat', 'MyStat', 'MyRank');