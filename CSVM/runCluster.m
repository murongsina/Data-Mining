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

% 聚类方法
Methods = {
    'Initial', 'KMeans', 'AGNES', 'BiKMeans'
};
% 输出结果
Range = [1 2];
nD = length(Range);
nM = length(Methods);

% 开启图表绘制
h = figure('Visible', 'on');
title('Performance of Clustering');

% 对每一个数据集
nIndex = 0;
for i = Range
    %进行编号
    nIndex = nIndex + 1;
    D = Datasets{i};
    % 重新整理数据标签的顺序
    D = DataLabel(D, LabelColumn(i));
    [ X, Y ] = SplitDataLabel(D);
    % 对每一种聚类算法
    for j = 1 : nM
        % 进行聚类
        fprintf('Cluster:%s on %s\n', Methods{j}, DatasetNames{i});
        [C, V, Time] = Cluster(X, Y, Methods{j}, LabelNumber(i));
        CorrectRate = mean(C==Y);
        fprintf('Methods:%s\t%4.5f\t%d\n', Methods{i}, CorrectRate, Time);
        % 绘制聚类结果
        S = [X, C];
        PlotMultiClass(S, Methods{j}, 2, 2, j, 6, Colors);
        % 绘制聚类中心
        PlotMultiClass(V, Methods{j}, 2, 2, j, 32, Colors);
    end
    hold on;
    saveas(h, [images, 'Cluster-', DatasetNames{i}, '.png']);
    clf(h);
end