images = '../images/MultiClf/KTWSVM';

% 实验用数据集
DataSets = Artificial;
DataSetIndices = [1 2 4 6];
% 构造分类器
Clf1 = CSVM(1.2, 'rbf', 1136.5, 3.6);
Clf2 = TWSVM(1.2, 1.2);
Clf3 = KTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
Clf = Clf3;
% 输出结果
nD = length(DataSetIndices);
Output = cell(nD, 8);
% 开启绘图模式
h = figure('Visible', 'on');
fprintf('runCrossValid\n');
% 在三个数据集上测试
for i = 1 : nD
    % 选择数据集
    DataSet = DataSets(DataSetIndices(i));
    % 转换多分类器
    Clfs = MultiClf(Clf, DataSet.Classes, DataSet.Labels);
    % 分割样本标签
    [X, Y] = SplitDataLabel(DataSet.Data);
    % 交叉验证索引
    ValInd = CrossValInd( Y, DataSet.Classes, DataSet.Labels, 5 );
    % 交叉验证
    [ Accuracy, Precision, Recall, Time ] = CrossValid( Clfs, X, Y, ValInd, 5 );
    % 保存结果
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
bar(Output{:,5:8});

% 保存结果
csvwrite('runCrossValid.txt', Output);
xlswrite('runCrossValid.mat', Table);