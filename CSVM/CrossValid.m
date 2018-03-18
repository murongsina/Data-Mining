function [ Accuracy, Precision, Recall, Time ] = CrossValid( Clf, X, Y, ValInd, k )
%CROSSVALID 此处显示有关此函数的摘要
% k折交叉验证
%   此处显示详细说明
% 参数：
%         Clf    -分类器
%           D    -数据集
%      ValInd    -交叉验证索引
%           k    -k折交叉验证
% 输出：
%    Accuracy    -精确度
%   Precision    -准确度
%      Recall    -召回率
%        Time    -平均训练时间

    % 训练时间
    Times = zeros(1, k);
    % 分类效果
    cp = classperf(Y);
    % 实验记进行k次(交叉验证折数)，求k次的平均值作为实验结果
    for i = 1 : k
        fprintf('CrossValid: %d', i);
        % 得到训练和测试集索引
        test = (ValInd == i);
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