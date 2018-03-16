images = '../images/CSVM/';

% 实验用数据集
DataSets = Artificial;
DataSetIndices = [1 2 4 6];
% 构造分类器
Clf1 = CSVM(1.2, 'rbf', 1136.5, 3.6);
Clf2 = TWSVM(1.2, 1.2);
Clf3 = KTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
% 参数区间
C = -3:1:3;
P1 = 2:1:6;
% 输出结果
nD = length(DataSetIndices);
Output = cell(nD, 8);
% 开启绘图模式
h = figure('Visible', 'on');
fprintf('runGridSearch\n');
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
    % 网格搜索
    % Output = GridSearch( Data, 10, P1, P2 );
    Output = GridSearchCV(Clf, X, Y, ValInd, k, P1, P2);
    
    % 保存结果
    saveas(h, [images, 'runGridSearch.png']);
end

csvwrite('runGridSearch.csv', Output);
xlswrite('runGridSearch.xls', Output);