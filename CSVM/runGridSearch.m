images = '../images/CSVM/GridSearch/';

% 实验用数据集
DataSets = Artificial;
DataSetIndices = [1 2 4 6];
% 核函数参数
RangeP1 = 2^(1:1:6)';
Params0 = struct('kernel', 'rbf', 'p1', RangeP1);
% 分类器网格搜索参数
RangeC = 2^(1:1:6)';
RangeC1 = 2^(1:1:6)';
RangeC2 = 2^(1:1:6)';
Params1 = struct('Name', 'CSVM', 'C', RangeC, 'Kernel', Params0);
Params2 = struct('Name', 'TWSVM', 'C1', RangeC1, 'C2', RangeC2);
Params3 = struct('Name', 'KTWSVM', 'C1', RangeC1, 'C2', RangeC2, 'Kernel', Params0);
Params4 = struct('Name', 'LSTWSVM', 'C1', RangeC1, 'C2', 2^(1:1:6)', 'Kernel', Params0);
Params5 = struct('Name', 'KNNSTWSVM', 'c1', RangeC1, 'c2', RangeC2, 'c3', RangeC1, 'c4', RangeC12, 'Kernel', Params0);
% 转换参数表
Params = {Params1,Params2,Params3,Params4,Params5};
ParamIndices = [1 3 4];
% 输出结果
Kfold = 5;
nD = length(DataSetIndices);
nP = length(ParamIndices);
Outputs = cell(nD, 8);
% 开启绘图模式
fprintf('runGridSearch\n');
% 对每一个数据集
for i = 1 : nD
    DataSet = DataSets(DataSetIndices(i));
    fprintf('runGridSearch: %s\n', DataSet.Name);
    % 分割样本标签
    [X, Y] = SplitDataLabel(DataSet.Data);
    % 交叉验证索引
    ValInd = CrossValInd( Y, DataSet.Classes, DataSet.Labels, Kfold );
    % 对每一组实验参数
    for j = 1 : nP
        % 初始化参数表
        IParams = Classifier.CreateParams(Params{ParamIndices(j)});
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