images = '../images/CSVM/';
datasets = '../datasets/artificial/';

% 数据集名称
DatasetNames = {
    'Sine-4000', 'Grid-4000', 'Ring-4000'
};

% 加载数据集
load([datasets, 'Datasets.mat'], 'Datasets');

% 样本选择方法
Methods = {
    'ALL', 'NPPS', 'NDP', 'FNSSS', 'DSSM', 'KSSM'
};

ADD = ['CBD', 'ENNC', 'BEPS'];

% 设置模型参数
C = 1136.5;
Sigma = 3.6;
kFold = 10;
% 输出结果
nD = length(Datasets);
nM = length(Methods);
Output = zeros(nD*nM, 5);

% 开启图表绘制
h = figure('Visible', 'on');

% 对每一个数据集
for i = 1 : nD
    D = Datasets{i};
    [m, ~] = size(D);
    fprintf('%s:\n', DatasetNames{i});
    % 对每一种样本选择算法
    for j = 1 : nM
        % 进行样本选择
        fprintf('Filter:%s on %s\n', Methods{j}, DatasetNames{i});
        [D1, T] = Filter(D, Methods{j});
        [n, ~] = size(D1);
        SelectRate = n/m;
        % 选择后的数据集上做交叉验证
        fprintf('CrossValid:%s on reduced %s\n', Methods{j}, DatasetNames{i});
        [ Accuracy, Precision, Recall ] = CrossValid( D1, kFold, C, Sigma  );
        Output(sub2ind([nM, nD], j, i), :) = [ SelectRate, T, Accuracy, Precision, Recall ];
        % 绘制样本选择结果
        PlotDataset(D1, 3, 2, j, Methods{j}, 6, 'xr', '+g');
    end
    hold on;
    saveas(h, [images, DatasetNames{i}, '.png']);
    clf(h);
end

% 绘制条形图
plot(Output);

% 保存图表
saveas(h, [images, 'runExperiments.png']);

% 保存结果
csvwrite('runExperiments.csv', Output);
xlswrite('runExperiments.xls', Output);