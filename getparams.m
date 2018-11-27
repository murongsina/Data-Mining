Path = './data/classify/rbf/';

load([Path, '\5-fold\MTvTWSVM2-Monk-S120.mat']);
load('LabCParams.mat');

% 得到参数
Param = CParams{7};
[ BestParam, Accuracy, Result, L, R ] = GetBestParam(Param, CVStat, 'rho', 'v1');
xlabel('\mu_1(\mu_2)');
ylabel('\nu_1(\nu_2)');
