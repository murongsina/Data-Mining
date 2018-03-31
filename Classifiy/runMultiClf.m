datasets = 'datasets/';
images = 'images/MultiClf/';

addpath(genpath('./datasets/'));
addpath(genpath('./model/'));
addpath(genpath('./utils/'));
% 实验用数据集
load('Artificial.mat');
DataSetIndices = [1 2];% 4 6 7 8 9 12 13];
% 输出结果
nD = length(DataSetIndices);
Output = cell(nD, 6);
% 构造基分类器
Params0 = struct('kernel', 'rbf', 'p1', 1136.5);
Params1 = struct('Name', 'KTWSVM', 'C1', 2, 'C2', 2, 'Kernel', Params0); 
% 开启绘图模式
% h = figure('Visible', 'on');
fprintf('runMultiClf\n');
for j = 1 : nD
    % 选择数据集
    DataSet = Artificial(DataSetIndices(j));
    % 标准化数据集
    fprintf('Normalize %s:\n', DataSet.Name);
%     Data = Normalize(DataSet.Data, DataSet.LabelColumn);
    % 转换多分类器
    fprintf('MultiClf...\n');
    % 分割数据集
    fprintf('SplitDataset %s:\n', DataSet.Name);
    [DTrain, DTest] = SplitTrainTest(DataSet.Data, 0.80);
    [XTrain, YTrain] = SplitDataLabel(DTrain);
    [XTest, YTest] = SplitDataLabel(DTest);
    % 训练
    opts.Classes =  DataSet.Classes;
    opts.Labels = DataSet.Labels;
    opts.Mode = 'OvO';
    opts.Params = Params1;
    fprintf('MultiClf %s Fit and Predict...\n', Params1.Name);
    [ yTest, Time ] = MultiClf(XTrain, YTrain, XTest, opts);
    Accuracy = mean(yTest==YTest);
    D1 = [XTest yTest];
    Output(j, :) = {
        DataSet.Name, DataSet.Instances, DataSet.Attributes, DataSet.Classes,...
        Accuracy, Time
    };
    fprintf('PlotMultiClass...\n');
    % 绘图
%     PlotTrainTest( h, images, DataSet, D1, DTrain, DTest, Colors );
end

% 保存结果
Table = cell2table(Output, 'VariableNames', {'DataSet', 'Instances', 'Attributes', 'Classes', 'Accuracy', 'Time'});
Table

% save([images, 'Table.mat'], Table);
% csvwrite('runMultiClf.csv', Output);
% xlswrite('runMultiClf.xls', Output);