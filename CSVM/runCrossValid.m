images = '../images/CSVM/';
datasets = '../datasets/artificial/';

% 数据集
DataSets = datas;

% 加载数据集
% load([datasets, 'DataSets.mat'], 'Datasets');

% 打开文件
fprintf('Datasets\tAccuracy\tRecall\tPrecision\tTime(s)\n');

% 开启绘图模式
fprintf('runCrossValid');
h = figure('Visible', 'on');

% 设置模型参数
C = 1136.5;
Sigma = 3.6;
Output = zeros(n, 5);
 
% 在三个数据集上测试
for i = 1 : n
    DataSet = DataSets(i);
    fprintf('CrossValid: on %s\n', DataSet.Name);
    Output(i, :) = CrossValid( DataSet.Data, 10, C, Sigma );
end

% 绘制条形图
bar(Output);

% 保存结果
csvwrite('runCrossValid.txt', Output);