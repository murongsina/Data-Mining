images = '../images/Filter/';
datasets = '../datasets/artificial/';

% 数据集
DataSets = Artificial;
% 分类器
Clf1 = KSVM(1.2, 'rbf', 1136.5);
Clf2 = TWSVM(1.2, 1.2);
Clf3 = KTWSVM(1.2, 1.2, 'rbf', 1136.5);
Clf4 = LSTWSVM(1.2, 1.2, 'rbf', 1136.5);
Clf5 = AdaBoost({Clf1, Clf2, Clf3, Clf4});
Clf6 = KNNSTWSVM(1.1, 1.3, 1.5, 1.7, 'rbf', 1136.5);
Clf7 = BP();
Clfs = {Clf1, Clf2, Clf3, Clf4, Clf5, Clf6, Clf7};
% 样本选择方法
Filters = {
    'ALL', 'NPPS', 'NDP', 'DSSM', 'KSSM', 'CBD', 'FNSSS', 'ENNC', 'BEPS'
};
% 实验用数据集和样本选择方法
DataSetIndices = [5 10 11];
FilterIndices = [1 2 3 4 5 6];
% 输出结果
nD = length(DataSetIndices);
nM = length(FilterIndices);
Output = zeros(nD*nM, 6);
% 参数区间
P1 = -3:1:3;
P2 = 2:1:6;
P3 = 2:1:6;
kFold = 5;
% 开启图表绘制
h = figure('Visible', 'on');
title('Performance of five Sample Selection Algorithm');

% 对每一个数据集
for i = 1 : nD
    clf(h);
    % 选取数据集
    DataSet = DataSets(DataSetIndices(i));
    Data = DataLabel(DataSet.Data, DataSet.LabelColumn);
    fprintf('%s:\n', DataSet.Name);
    % 对每一种样本选择算法
    for j = 1 : nM
        % 样本选择方法
        FilterName = Filters{FilterIndices(j)};
        % 进行样本选择
        fprintf('Filter:%s on %s\n', FilterName, DataSet.Name);
        [D1, T] = Filter(Data, FilterName);
        [n, ~] = size(D1);
        SelectRate = n/Data.Instances;
        % 分割样本标签
        [X, Y] = SplitDataLabel(DataSet.Data);
        % 交叉验证索引
        ValInd = CrossValInd( Y, DataSet.Classes, DataSet.Labels, 5 );
        % 选择后的数据集上做网格搜索和交叉验证
        fprintf('GridSearchCV:%s on reduced %s\n', Filters{j}, DataSet.Name);
        GridSearchCV(Clf, X, Y, ValInd, kFold, P1, P2, P3);
        % 绘制样本选择结果
        PlotDataset(D1, 3, 2, j, Filters{j}, 6, 'xr', '+g');
    end
    hold on;
    saveas(h, [images, DataSet.Name, '.png']);
end

% 保存图表
saveas(h, [images, 'runExperiments.png']);

% 保存结果
csvwrite('runExperiments.csv', Output);
xlswrite('runExperiments.xls', Output);