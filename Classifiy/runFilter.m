images = '../images/Filter/';
datasets = '../datasets/artificial/';

% 数据集
DataSets = ShapeSets;
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
Output = zeros(nD*nM, 2);
% 开启图表绘制
h = figure('Visible', 'on');
title('Performance of five Sample Selection Algorithm');
% 显示数据集信息
PrintDataInfo(DataSets(DataSetIndices));
% 对每一个数据集
for i = 1 : nD
    clf(h);
    % 选取数据集
    DataSet = DataSets(DataSetIndices(i));
    Data = DataLabel(DataSet.Data(1:1000,:), DataSet.LabelColumn);
    fprintf('%s:\n', DataSet.Name);
    % 对每一种样本选择算法
    for j = 1 : nM
        % 样本选择方法
        FilterName = Filters{FilterIndices(j)};
        % 进行样本选择
        fprintf('Filter:%s on %s\n', FilterName, DataSet.Name);        
        [D1, T] = Filter(Data, FilterName);
        [n, ~] = size(D1);
        SelectRate = n/DataSet.Instances;
        % 构造输出矩阵
        Output(sub2ind([nM, nD], j, i), :) = [ SelectRate, T ];
        % 绘制样本选择结果
        PlotDataset(D1, 3, 2, j, FilterName, 6, 'xr', '+g');
    end
    hold on;
    saveas(h, [images, 'Filter-', DataSet.Name, '.png']);
end

% 保存结果
csvwrite('runFilter.csv', Output);
xlswrite('runFilter.xls', Output);