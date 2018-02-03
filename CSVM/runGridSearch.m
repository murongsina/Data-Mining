images = '../images/CSVM/';

% 数据集名称
DatasetNames = {
    'Sine-4000', 'Grid-4000', 'Ring-4000'
};

% 加载数据集
load([datasets, 'Datasets.mat'], 'Datasets');

% 取第一个数据集前400个样本做实验
D = Datasets{1};
D = D(1:1000,:);
% 参数区间
C = -3:1:3;
Sigma = 2:1:6;
% 网格搜索
[ Output ] = GridSearch( D, 10, 2.^C, 2.^Sigma );

% 线条样式
styles = {
    '-r', '-g', '-b', '-y', '-c'
};
% 绘制折线图
h = figure();
bar(Output);

saveas(h, [images, 'runGridSearch.png']);

% 保存结果
csvwrite('runGridSearch.csv', Output);
xlswrite('runGridSearch.xls', Output);