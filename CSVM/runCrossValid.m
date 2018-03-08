images = '../images/MultiClf/KTWSVM';

% 实验用数据集
DataSets = Artificial;
DataSetIndices = [1 2 4 6];
% 输出结果
nD = length(DataSetIndices);
Output = zeros(nD, 4);
% 构造分类器
% Clf = SVM('rbf', 1136.5, 12);
% Clf = CSVM(1136.5, 3.6);
% Clf = TWSVM(1.2, 1.2);
Clf = KTWSVM('rbf', 1.2, 1.2, 1136.5, 3.6);
% 开启绘图模式
h = figure('Visible', 'on');

fprintf('runCrossValid\n');
% 在三个数据集上测试
for i = 1 : nD
    % 选择数据集
    DataSet = DataSets(DataSetIndices(i));
    fprintf('CrossValid: on %s\n', DataSet.Name);
    % 转换多分类器
    Clfs = MultiClf(Clf, DataSet.Classes, DataSet.Labels);
    % 交叉验证
    Output(i, :) = CrossValid(Clfs, DataSet.Data, 5);
end

% 绘制条形图
bar(Output);

% 保存结果
csvwrite('runCrossValid.txt', Output);