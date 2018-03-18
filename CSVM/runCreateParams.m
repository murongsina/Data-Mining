% 核函数参数
RangeP1 = 2.^(1:1:6)';
Params0 = struct('kernel', 'rbf', 'p1', RangeP1);
% 分类器网格搜索参数
RangeC = 2.^(1:1:6)';
RangeC1 = 2.^(1:1:6)';
RangeC2 = 2.^(1:1:6)';
Params1 = struct('Name', 'CSVM', 'C', RangeC, 'Kernel', Params0);
Params2 = struct('Name', 'TWSVM', 'C1', RangeC1, 'C2', RangeC2);
Params3 = struct('Name', 'KTWSVM', 'C1', RangeC1, 'C2', RangeC2, 'Kernel', Params0);
Params4 = struct('Name', 'LSTWSVM', 'C1', RangeC1, 'C2', RangeC2, 'Kernel', Params0);
Params5 = struct('Name', 'KNNSTWSVM', 'c1', RangeC1, 'c2', RangeC2, 'c3', RangeC1, 'c4', RangeC2, 'Kernel', Params0);
% 转换参数表
OParams = {Params1,Params2,Params3,Params4,Params5};
nParams = length(OParams);
for i = 1 : nParams
    % 初始化参数表
    IParams{i, 1} = Classifier.CreateParams(OParams{i});
end
% 保存参数表
save('LabIParams.mat', 'IParams');