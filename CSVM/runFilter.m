images = '../images/CSVM/';
datasets = '../datasets/artificial/';

% 数据集名称
DatasetNames = {
    'Sine-4000', 'Grid-4000', 'Ring-4000'
};
% 数据集标签所在列
LabelIndex = [3, 3, 3];

% 加载数据集
load([datasets, 'Datasets.mat'], 'Datasets');

% 样本选择方法
Methods = {
    'ALL', 'NPPS', 'NDP', 'DSSM', 'KSSM', 'CBD'
};

% 输出结果
nD = length(Datasets);
nM = length(Methods);
Output = zeros(nD*nM, 2);

% 开启图表绘制
h = figure('Visible', 'on');
title('Performance of five Algorithm on Three Datasets');

% 对每一个数据集
for i = 1 : nD
    D = Datasets{i};
    D = D(1:1000,:);
    % 将标签排到最后一列，便于统一执行
    D = DataLabel(D, LabelIndex(i));
    [m, ~] = size(D);
    % 对每一种样本选择算法
    for j = 1 : nM
        % 进行样本选择
        fprintf('Filter:%s on %s\n', Methods{j}, DatasetNames{i});
        [D1, T] = Filter(D, Methods{j});
        [n, ~] = size(D1);
        SelectRate = n/m;
        % 构造输出矩阵
        Output(sub2ind([nM, nD], j, i), :) = [SelectRate, T];
        % 绘制样本选择结果
        PlotDataset(D1, 3, 2, j, Methods{j}, 6, 'xr', '+g');
    end
    hold on;
    saveas(h, [images, DatasetNames{i}, '-Filter.png']);
    clf(h);
end

% 保存结果
csvwrite('runFilter.csv', Output);
xlswrite('runFilter.xls', Output);