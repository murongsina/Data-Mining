images = '../images/MultiClf/LSTWSVM/';

% 实验用数据集
DataSets = Artificial;
DataSetIndices = [1 2 4 6 7 8 9 12 13];
% 输出结果
nD = length(DataSetIndices);
Output = cell(nD, 6);
% 构造分类器
% Clf = SVM(1136.5, 'rbf', 12);
% Clf = KSVM(1136.5, 'rbf', 3.6);
% Clf = TWSVM(1.2, 1.2);
% Clf = KTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
Clf = LSTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
% 开启绘图模式
h = figure('Visible', 'on');

fprintf('runMultiClf\n');
for i = 1 : nD
    % 选择数据集
    DataSet = DataSets(DataSetIndices(i));
    % 标准化数据集
%     fprintf('Normalize %s:\n', DataSet.Name);
%     Data = Normalize(DataSet.Data, DataSet.LabelColumn);
    % 转换多分类器
    fprintf('MultiClf...\n');
    Clfs = MultiClf(Clf, DataSet.Classes, DataSet.Labels);
    % 分割数据集    
    fprintf('SplitDataset %s:\n', DataSet.Name);
    [DTrain, DTest] = SplitTrainTest(DataSet.Data, 0.80);
    [XTrain, YTrain] = SplitDataLabel(DTrain);
    [XTest, YTest] = SplitDataLabel(DTest);
    % 训练
    fprintf('%s Fit...\n', Clfs.Name);
    [Clfs, Time] = Clfs.Fit(XTrain, YTrain);
    % 测试
    fprintf('Predict...\n');
    [yTest] = Clfs.Predict(XTest);
    Accuracy = mean(yTest==YTest);
    D1 = [XTest yTest];
    Output(i, :) = {
        DataSet.Name, DataSet.Instances, DataSet.Attributes, DataSet.Classes,...
        Accuracy, Time
    };
    fprintf('PlotMultiClass...\n');
    % 绘图
%     clf(h);
%     PlotMultiClass(DTrain, DataSet.Name, 1, 1, 1, 6, Colors);
%     saveas(h, [images, DataSet.Name, '-Train.png']);
%     savefig(h, [images, DataSet.Name, '-Train.fig']);
%     clf(h);
%     PlotMultiClass(DTest, DataSet.Name, 1, 1, 1, 6, Colors);
%     saveas(h, [images, DataSet.Name, '-Test.png']);
%     savefig(h, [images, DataSet.Name, '-Test.fig']);
%     clf(h);
%     PlotMultiClass(D1, DataSet.Name, 1, 1, 1, 6, Colors);
%     saveas(h, [images, DataSet.Name, '-Predict.png']);
%     savefig(h, [images, DataSet.Name, '-Predict.fig']);
end

% 保存结果
Table = cell2table(Output, 'VariableNames', {'DataSet', 'Instances', 'Attributes', 'Classes', 'Accuracy', 'Time'});
Table

% save([images, 'Table.mat'], Table);
% csvwrite('runMultiClf.csv', Output);
% xlswrite('runMultiClf.xls', Output);