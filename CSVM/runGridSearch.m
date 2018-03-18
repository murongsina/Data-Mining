images = '../images/CSVM/GridSearch/';

% 实验用数据集
DataSets = Artificial;
DataSetIndices = [1 2 4 6];
% 核函数参数
Params0 = struct('kernel', 'rbf', 'p1', 2.^(1:1:6)');
% 分类器网格搜索参数
Params1 = struct('Name', 'CSVM', 'C', (1:1:6)', 'Kernel', Params0);
Params2 = struct('Name', 'TWSVM', 'C1', (1:1:6)', 'C2', (1:1:6)');
Params3 = struct('Name', 'KTWSVM', 'C1', (1:1:6)', 'C2', (1:1:6)', 'Kernel', Params0);
Params4 = struct('Name', 'LSTWSVM', 'C1', (1:1:6)', 'C2', (1:1:6)', 'Kernel', Params0);
Params5 = struct('Name', 'KNNSTWSVM', 'c1', (1:1:6)', 'c2', (1:1:6)', 'c3', (1:1:6)', 'c4', (1:1:6)', 'Kernel', Params0);
% 转换参数表
Params = {Params1,Params2,Params3,Params4,Params5};
% 输出结果
Kfold = 5;
nD = length(DataSetIndices);
nP = length(Params);
Outputs = cell(nD, 8);
% 开启绘图模式
h = figure('Visible', 'on');
fprintf('runGridSearch\n');
% 对每一个数据集
for i = 1 : nD
    DataSet = DataSets(DataSetIndices(i));
    % 对每一组实验参数
    for j = 1 : nP
        % 分割样本标签
        [X, Y] = SplitDataLabel(DataSet.Data);
        % 交叉验证索引
        ValInd = CrossValInd( Y, DataSet.Classes, DataSet.Labels, Kfold );
        % 初始化参数
        IParams = Classifier.CreateParams(Params{j});
        % 根据第一组参数初始化二分类器
        Clf = Classifier.CreateClf(IParams(1));
        % 转换多分类器
        Clfs = MultiClf(Clf, DataSet.Classes, DataSet.Labels);
        % 网格搜索、交叉验证
        Outputs = GridSearchCV(Clfs, X, Y, ValInd, IParams, Kfold);
        % 保存网格搜索交叉验证的结果
        Outputs(i, j) = {
            DataSet.Name, DataSet.Instances, DataSet.Attributes, DataSet.Classes, Output
        };
    end
end

% save('runGridSearch.mat', Output);