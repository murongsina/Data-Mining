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
    'NPPS', 'NDP', 'FNSSS', 'DSSM', 'KSSM'
};

% 设置模型参数
C = 1136.5;
Sigma = 3.6;
% 输出结果
nD = length(Datasets);
nM = length(Methods);
Output = zeros(nD*nM, 12);

% 开启图表绘制
h = figure('Visible', 'on');

% 对每一个数据集
for i = 1 : length(Datasets)
    D = Datasets{i};
    [m, ~] = size(D);
    fprintf('%s:\n', DatasetNames{i});
    % 绘制选择前后的样本
    PlotDataset(D, 3, 2, 1, 'ALL', 6, 'xr', '+g');
    % 对每一种样本选择算法
    for j = 1 : length(Methods)
        % 进行样本选择
        [D1, T] = SSMWrapper(D, Methods{j});
        [n, ~] = size(D1);
        SelectRate = n/m;
        % 在原始数据集和选择后的数据集上做交叉验证
        [ Recall, Precision, Accuracy, FAR, FDR ] = CrossValid( D, n, C, Sigma  );
        CV1 = [ Recall, Precision, Accuracy, FAR, FDR ];
        [ Recall, Precision, Accuracy, FAR, FDR ] = CrossValid( D1, n, C, Sigma  );
        CV2 = [ Recall, Precision, Accuracy, FAR, FDR ];
        % 构造输出矩阵
        Output(i*j, :) = [SelectRate, T, CV1, CV2];
        % 绘制样本选择结果
        PlotDataset(D1, 3, 2, j, Methods{j}, 6, 'xr', '+g');
    end
    hold on;
    saveas(h, [images, DatasetNames{i}, '.png']);
    clf(h);
end

% 绘制条形图
plot(Output);

% 保存结果
csvwrite('runExperiments.txt', Output);