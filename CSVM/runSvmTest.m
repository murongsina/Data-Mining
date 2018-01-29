images = '../images/CSVM/';
datasets = '../datasets/artificial/';

% 数据集名称
DatasetNames = {
    'Sine-4000', 'Grid-4000', 'Ring-4000'
};

% 加载数据集
load([datasets, 'Datasets.mat'], 'Datasets');

% 构造分类器
% clf = SVM('rbf', 1136.5, 12);
clf = CSVM(1136.5, 3.6);

% 打开文件
fid = fopen('Experiments-CSVM.txt', 'w');
fprintf(fid, 'Datasets\tAccuracy\tTime(s)\n');

% 开启绘图模式
h = figure('Visible', 'on');
for i = 1 : length(DatasetNames)
    fprintf('%s:\n', DatasetNames{i});
    D = Datasets{i};
    fprintf('SplitDataset\n');
    DTrain = D(1:800, :);
    DTest = D(801:1000, :);
    fprintf('SplitDataLabel\n');
    [XTrain, YTrain] = SplitDataLabel(DTrain);
    [XTest, YTest] = SplitDataLabel(DTest);
    fprintf('Fit...\n');
    [clf, Time] = clf.Fit(XTrain, YTrain);
    fprintf('Predict...\n');
    [clf, yTest] = clf.Predict(XTest);
    Accuracy = mean(yTest==YTest);
    D1 = [XTest yTest];
    fprintf('%s\t%8.5f\t%8.5f\n', DatasetNames{i}, Accuracy, Time);
    fprintf(fid, '%s\t%8.5f\t%8.5f\n', DatasetNames{i}, Accuracy, Time);
    fprintf('PlotDataset...\n');
    PlotDataset(D1, 3, 3, i*3, DatasetNames{i}, 6, 'xr', '+g');
    PlotDataset(DTest, 3, 3, i*3-1, DatasetNames{i}, 6, 'xr', '+g');
    PlotDataset(DTrain, 3, 3, i*3-2, DatasetNames{i}, 6, 'xr', '+g');
end
saveas(h, [images, 'CSVM_D1000.png']);
fclose(fid);