images = '../images/CSVM/';
datasets = '../datasets/artificial/';

% 数据集名称
DatasetNames = {
    'LR', 'wine', 'wine-quality-red', 'wine-quality-white', 'wifilocalization'
};
% 数据集
Datasets = { LR, wine, winequalityred, winequalitywhite, wifilocalization };
% 数据集标签所在列
LabelColumn = [3, 1, 12, 12, 8];
% 数据集分类数
LabelNumber = [2, 3, 6, 7, 4];
% 颜色列表
Colors = [ 
    255 0 0; 0 255 0; 0 0 255; 255 255 0; 255 0 255; 0 255 255; ...
    255 128 0; 255 0 128; 128 0 255; 128 255 0; 0 255 128; 0 128 255 ...
];
Colors = Colors / 255;

% 输出结果
Range = [1 2 3];
nD = length(Range);

% 开启图表绘制
h = figure('Visible', 'on');
title('Performance of Clustering');

% 对每一个数据集
for i = Range
    D = Datasets{i};
    % 重新整理数据标签的顺序
    D = DataLabel(D, LabelColumn(i));
    % 聚类
    [ X, YTrue ] = SplitDataLabel(D);
    tic;
%     [ C, V ] = KMeans(X, LabelNumber(i));
    [ C ] = AGNES( X,  LabelNumber(i), 'min' );
    Time = toc;
    CorrectRate = mean(C==YTrue);
    fprintf('Dataset:%s\t%4.5f\t%d\n', DatasetNames{i}, CorrectRate, Time);
    % 绘制原始数据集
    PlotMultiClass(D, DatasetNames{i}, nD, 2, i*2-1, 6, Colors);
    % 绘制聚类结果
    D1 = [X, C];
    PlotMultiClass(D1, DatasetNames{i}, nD, 2, i*2, 6, Colors);
    % 绘制聚类中心
%     PlotMultiClass(V, DatasetNames{i}, nD, 2, i*2, 32, Colors);
end
saveas(h, [images, 'runClustering-AGNES.png']);