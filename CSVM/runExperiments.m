images = '../images/Filter/';
datasets = '../datasets/artificial/';

% 数据集
DataSets = ShapeSets;
% 分类器
Clf1 = KSVM(1136.5, 'rbf', 3.6);
Clf2 = TWSVM(1.2, 1.2);
Clf3 = KTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
Clf4 = LSTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
Clf5 = AdaBoost({Clf1, Clf2, Clf3, Clf4});
Clf6 = KNNSTWSVM(1.1, 1.3, 1.5, 1.7, 'rbf', 1136.5, 3.6);
Clf7 = BP();
Clfs = {Clf1, Clf2, Clf3, Clf4, Clf5, Clf6, Clf7};
% 样本选择方法
Filters = {
    'ALL', 'NPPS', 'NDP', 'DSSM', 'KSSM', 'CBD', 'FNSSS', 'ENNC', 'BEPS'
};
% 实验用数据集和样本选择方法
DataSetIndices = [1 2 3 4 5 6];
FilterIndices = [1 2 3 4 5 6];
% 输出结果
nD = length(DataSetIndices);
nM = length(FilterIndices);
Output = zeros(nD*nM, 5);
% 设置模型参数
C = 1136.5;
Sigma = 3.6;
kFold = 10;
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
        % 选择后的数据集上做交叉验证
        fprintf('CrossValid:%s on reduced %s\n', Filters{j}, DataSet.Name);
        [ Accuracy, Precision, Recall ] = CrossValid( Clf3, DataSet.Data, kFold, C, Sigma  );
        Output(sub2ind([nM, nD], j, i), :) = [ SelectRate, T, Accuracy, Precision, Recall ];
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