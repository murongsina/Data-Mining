function [ Accuracy, Precision, Recall, Time ] = CrossValid( Clf, D, k )
%CROSSVALID 此处显示有关此函数的摘要
% n折交叉验证
%   此处显示详细说明
% 参数：
%    Clf    -分类器
%      D    -数据集
%      k    -k折交叉验证

    fprintf('CrossValid: %d fold, CSVM(%4.6f, %4.6f)\n', k);
    % 分割样本标签
    [X, Y] = SplitDataLabel(D);
    Y(Y==-1) = 0;
    % 记录时间
    Times = zeros(1, k);
    % 交叉验证
    indices = crossvalind('Kfold', Y, k);
    cp = classperf(Y);
    % 实验记进行k次(交叉验证折数)，求k次的平均值作为实验结果
    for i = 1 : k
        fprintf('CrossValid:%d\n', i);
        % 得到训练和测试集索引
        test = (indices == i);
        train = ~test;
        % 在训练集上训练
        [Clf, Time] = Clf.Fit(X(train,:), Y(train,:));
        % 在测试集上测试
        [yTest] = Clf.Predict(X(test,:));
        % 分类性能
        classperf(cp, yTest, test);
        % 记录时间
        Times(1, i) = Time;
    end
    Accuracy = cp.CorrectRate;
    Precision = cp.PositivePredictiveValue;
    Recall = cp.Sensitivity;
    Time = mean(Times);
end