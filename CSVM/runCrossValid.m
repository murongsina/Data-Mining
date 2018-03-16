images = '../images/MultiClf/KTWSVM';

% 实验用数据集
DataSets = Artificial;
DataSetIndices = [1 2 4 6];
% 输出结果
nD = length(DataSetIndices);
Output = cell(nD, 8);
% 构造分类器
% Clf = SVM('rbf', 1136.5, 12);
% Clf = CSVM(1136.5, 3.6);
% Clf = TWSVM(1.2, 1.2);
Clf = KTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
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
    [ Accuracy, Precision, Recall, Time ] = CrossValid( Clfs, DataSet, 5 );
    Output(i, :) = {
        DataSet.Name, DataSet.Instances, DataSet.Attributes, DataSet.Classes,...
        Accuracy, Precision, Recall, Time
    };
end

% 保存结果
Table = cell2table(Output, 'VariableNames', {
    'DataSet', 'Instances', 'Attributes', 'Classes',...
    'Accuracy', 'Precision', 'Recall', 'Time'
});
Table

% 绘制条形图
bar(Output);

% 保存结果
csvwrite('runCrossValid.txt', Output);
xlswrite('runCrossValid.mat', Table);