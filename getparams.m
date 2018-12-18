Path = './data/classify/rbf/';

load([Path, '\5-fold\MTvTWSVM2-Caltech256_V2_T3.mat']);
%%
load('LabCParams.mat');
Param = CParams{7};
%% 得到参数
[ BestParam, Accuracy, Result, L, R ] = GetBestParam(Param, CVStat, 'rho', 'v1');
xlabel('\mu_1(\mu_2)');
ylabel('\nu_1(\nu_2)');
