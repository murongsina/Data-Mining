% 核函数参数
RangeP1 = 2.^(1:1:6)';
Params0 = struct('kernel', 'rbf', 'p1', RangeP1);
% 分类器网格搜索参数
C = 2.^(1:1:6)';
C1 = 2.^(1:1:6)';
C2 = 2.^(1:1:6)';
EPS1 = (1:2:16)';
EPS2 = (1:2:16)';
Params1 = struct('Name', 'MTL_TWSVR', 'C1', C1, 'C2', C2, 'eps1', EPS1, 'eps2', EPS2, 'Kernel', Params0);
% 转换参数表
OParams = {Params1};
nParams = length(OParams);
for i = 1 : nParams
    % 初始化参数表
    IParams{i, 1} = Classifier.CreateParams(OParams{i});
end
% 保存参数表
save('LabIParams.mat', 'IParams');