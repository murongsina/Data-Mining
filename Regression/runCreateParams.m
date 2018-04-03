addpath(genpath('./utils'));

% 核函数参数
RangeP1 = 2.^(1:2:9)';
kernel = struct('kernel', 'rbf', 'p1', RangeP1);
% 分类器网格搜索参数
C = 2.^(1:2:9)';
C1 = 2.^(1:2:9)';
C2 = 2.^(1:2:9)';
C3 = 2.^(1:2:9)';
C4 = 2.^(1:2:9)';
EPS1 = 2.^(1:2:9)';
EPS2 = 2.^(1:2:9)';
RHO = 2.^(1:3:10)';
LAMBDA = 2.^(1:3:10)';
Params0 = struct('Name', 'TWSVR', 'C1', C1, 'C2', C2, 'C3', C3, 'C4', C4, 'eps1', EPS1, 'eps2', EPS2, 'Kernel', kernel);
Params1 = struct('Name', 'TWSVR_Xu', 'C1', C1, 'C2', C2, 'eps1', EPS1, 'eps2', EPS2, 'Kernel', kernel);
Params2 = struct('Name', 'MTL_TWSVR', 'C1', C1, 'C2', C2, 'eps1', EPS1, 'eps2', EPS2, 'Kernel', kernel);
Params3 = struct('Name', 'MTL_TWSVR_Xu', 'C1', C1, 'C2', C2, 'eps1', EPS1, 'eps2', EPS2, 'Kernel', kernel);
Params4 = struct('Name', 'MTL_TWSVR_Mei', 'C1', C1, 'C2', C2, 'eps1', EPS1, 'eps2', EPS2, 'rho', RHO, 'lambda', LAMBDA, 'Kernel', kernel);
% 转换参数表
OParams = {Params0;Params1;Params2;Params3;Params4};
nParams = length(OParams);
for i = 1 : nParams
    % 初始化参数表
    fprintf('Params\n')
    IParams{i, 1} = CreateParams(OParams{i});
end
% 保存参数表
save('LabIParams.mat', 'IParams');