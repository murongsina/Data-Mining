images = '../images/CSVM/GridSearch/';

addpath(genpath('./model'));
addpath(genpath('./filter'));
addpath(genpath('./clustering'));
addpath(genpath('./datasets'));
addpath(genpath('./utils'));

load('Artificial.mat');
load('LabIParams.mat');

% 实验用数据集
DataSets = Artificial;
DataSetIndices = [1 2 4 6];
% 实验参数设置
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
    % 设置多分类选项
    opts.Classes = DataSet.Classes;
    opts.Labels = DataSet.Labels;
    opts.Mode = 'OvO';
    % 对每一个实验
    for j = 1 : nP
        % 网格搜索、交叉验证
        Outputs = GridSearchCV(@MultiClf, X, Y, Kfold, ValInd, IParams{j}, opts);
        % 保存网格搜索交叉验证的结果
        Outputs(i, j) = {
            DataSet.Name, DataSet.Instances, DataSet.Attributes, DataSet.Classes, Output
        };
    end
end

% save('runGridSearch.mat', Output);