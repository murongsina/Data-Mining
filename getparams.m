Path = './data/classify/rbf/';
load('LabCParams.mat');

%% 得到参数
Param = CParams{7};
[ BestParam, Accuracy, L, R ] = GetBestParam(Param, CVStat, 'rho', 'v1');