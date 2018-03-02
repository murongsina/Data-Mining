images = '../images/Cluster/';
datasets = '../datasets/artificial/';

% 数据集
DataSets = datas;

% 聚类方法
Methods = {
    'Initial', 'KMeans', 'BiKMeans', 'AGNES'
};

% 输出结果
Range = [1 2 3 4 7 8 9];
nD = length(Range);
nM = length(Methods);

% 开启图表绘制
h = figure('Visible', 'on');
title('Performance of Clustering');

% 对每一个数据集
nIndex = 0;
for i = Range
    % 清空图像
    clf(h);
    % 进行编号
    nIndex = nIndex + 1;
    % 数据集
    DataSet = DataSets(i);
    % 重新整理数据标签的顺序
    D = DataLabel(DataSet.Data, DataSet.LabelColumn);
    [ X, Y ] = SplitDataLabel(D);
    % 对每一种聚类算法
    for j = 1 : nM
        % 进行聚类
        fprintf('Cluster:%s on %s\n', Methods{j}, DataSet.Name);
        [C, V, Time] = Cluster(X, Y, Methods{j}, DataSet.LabelNumber);
        CorrectRate = mean(C==Y);
        fprintf('Methods:%s\t%4.5f\t%d\n', Methods{j}, CorrectRate, Time);
        % 绘制聚类结果
        S = [X, C];
        PlotMultiClass(S, Methods{j}, 2, 2, j, 6, Colors);
        % 绘制聚类中心
        PlotMultiClass(V, Methods{j}, 2, 2, j, 32, Colors);
    end
    hold on;
    saveas(h, [images, 'Cluster-', DataSet.Name, '.png']);
end