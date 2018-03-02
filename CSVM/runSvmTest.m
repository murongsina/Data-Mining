images = '../images/CSVM/';
datasets = '../datasets/artificial/';

% 数据集名称
DataSets = datas;

% 加载数据集
% load([datasets, 'Datasets.mat'], 'Datasets');
nD = length(DataSets);

% 构造分类器
% clf = SVM('rbf', 1136.5, 12);
% clf = CSVM(1136.5, 3.6);
clf = CSVM(1136.5, 3.6);

% 输出结果
Output = zeros(nD, 2);

% 开启绘图模式
h = figure('Visible', 'on');
for i = 1 : nD
    DataSet = DataSets(i);
    fprintf('%s:\n', DataSet.Name);
    Data = DataSet.Data;
    fprintf('SplitDataset\n');
    DTrain = Data(1:1800, :);
    DTest = Data(1801:2000, :);
    fprintf('SplitDataLabel\n');
    [XTrain, YTrain] = SplitDataLabel(DTrain);
    [XTest, YTest] = SplitDataLabel(DTest);
    fprintf('Fit...\n');
    [clf, Time] = clf.Fit(XTrain, YTrain);
    fprintf('Predict...\n');
    [clf, yTest] = clf.Predict(XTest);
    Accuracy = mean(yTest==YTest);
    D1 = [XTest yTest];
    Output(i, :) = [Accuracy, Time];
    fprintf('PlotDataset...\n');
    PlotDataset(D1, 3, 3, i*3, DataSet.Name, 6, 'xr', '+g');
    PlotDataset(DTest, 3, 3, i*3-1, DataSet.Name, 6, 'xr', '+g');
    PlotDataset(DTrain, 3, 3, i*3-2, DataSet.Name, 6, 'xr', '+g');
end

% 保存图表
saveas(h, [images, 'runSvmTest.png']);

% 保存结果
csvwrite('runSvmTest.csv', Output);
xlswrite('runSvmTest.xls', Output);