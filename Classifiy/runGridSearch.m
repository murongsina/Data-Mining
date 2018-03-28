images = '../images/CSVM/GridSearch/';

% 实验用数据集
load('Artificial.mat');
DataSets = Artificial;
DataSetIndices = [1 2 4 6];
% 实验参数设置
load('LabIParams.mat');
IParams = LabIParams;
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
        % 选择实验参数
        Params = IParams{j};
        % 根据第一组参数初始化二分类器
        Clf = Classifier.CreateClf(Params(1));
        % 转换多分类器
        Clfs = MultiClf(Clf, DataSet.Classes, DataSet.Labels);
        % 网格搜索、交叉验证
        Outputs = GridSearchCV(Clfs, X, Y, ValInd, Params, Kfold);
        % 保存网格搜索交叉验证的结果
        Outputs(i, j) = {
            DataSet.Name, DataSet.Instances, DataSet.Attributes, DataSet.Classes, Output
        };
    end
end

% save('runGridSearch.mat', Output);