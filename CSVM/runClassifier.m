images = '../images/CSVM/';
datasets = '../datasets/artificial/';

% 数据集
DataSets = datas;

% 输出结果
nD = length(Datasets);

% 对每一个数据集
for i = 1 : nD
    DataSet = DataSets{i};
    % 重新整理数据标签的顺序
    D = DataLabel(DataSet.data, DataSet.LabelColumn);
    % LVQ
    [X, Y] = SplitDataLabel(D);
    [ P, t ] = LVQ( X, Y, DataSet.LabelNumber, 0.5, 40000 );
    lv = [P, t];
    % KMeans
    [Y, V] = KMeans(X, DataSet.LabelNumber);
    % 绘制原始数据集
    PlotMultiClass(D, DataSet.Name, nD, 3, i*3-2, 6, Colors);
    % 绘制lv
    PlotMultiClass(lv, DataSet.Name, nD, 3, i*3-1, 12, Colors);
    % 绘制聚类中心 
    PlotMultiClass(V, DataSet.Name, nD, 3, i*3, 12, Colors);
end