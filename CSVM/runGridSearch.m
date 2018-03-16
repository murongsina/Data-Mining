images = '../images/CSVM/GridSearch/';

% 实验用数据集
DataSets = Artificial;
DataSetIndices = [1 2 4 6];
% 构造分类器
Clf1 = CSVM(1136.5, 'rbf', 3.6);
Clf2 = TWSVM(1.2, 1.2);
Clf3 = KTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
Clf4 = LSTWSVM(1.2, 1.2, 'rbf', 1136.5, 3.6);
Clf5 = AdaBoost({Clf1, Clf2, Clf3, Clf4});
Clf6 = KNNSTWSVM(1.1, 1.3, 1.5, 1.7, 'rbf', 1136.5, 3.6);
Clfs = {Clf1, Clf2, Clf3, Clf4, Clf5, Clf6};
Clf = Clfs(6);
% 参数区间
P1 = -3:1:3;
P2 = 2:1:6;
P3 = 2:1:6;
% 输出结果
nD = length(DataSetIndices);
Outputs = cell(nD, 8);
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
    % 交叉验证
%     [ Accuracy, Precision, Recall, Time ] = CrossValid( Clf, X, Y, ValInd, k );
%     Output(i) = [ Accuracy, Precision, Recall, Time ];
    % 网格搜索
%     Output = GridSearch(Clf, X, Y, ValInd, k, 2.^P1, 2.^P2);
    % 网格搜索、交叉验证
    Output = GridSearchCV(Clf, X, Y, ValInd, k, 2.^P1, 2.^P2);
    % 保存网格搜索交叉验证的结果
    Outputs(1, :) = {
        DataSet.Name, DataSet.Instances, DataSet.Attributes, DataSet.Classes, Output
    };
end

csvwrite('runGridSearch.csv', Output);
xlswrite('runGridSearch.xls', Output);