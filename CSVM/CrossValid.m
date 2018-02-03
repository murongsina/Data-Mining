function [ Accuracy, Precision, Recall ] = CrossValid( D, n, C, Sigma )
%CROSSVALID 此处显示有关此函数的摘要
% n折交叉验证
%   此处显示详细说明
% 参数：
%      D    -数据集
%      n    -n折交叉验证
%      C    -参数C
%  Sigma    -参数σ

    % 初始化分类器参数
    clf = CSVM(C, Sigma);
    fprintf('CrossValid: %d fold, CSVM(%4.6f, %4.6f)\n', n, C, Sigma);
    % 分割样本标签
    [X, Y] = SplitDataLabel(D);
    Y(Y==-1) = 0;
    % 交叉验证
    indices = crossvalind('Kfold', Y, n);
    cp = classperf(Y);
    % 实验记进行n次(交叉验证折数)，求n次的平均值作为实验结果
    for i = 1 : n
        fprintf('CrossValid:%d\n', i);
        % 得到训练和测试集索引
        test = (indices == i);
        train = ~test;
        % 在训练集上训练
        [clf, ~] = clf.Fit(X(train,:), Y(train,:));
        % 在测试集上测试
        [clf, y] = clf.Predict(X(test,:));
        % 分类性能
        classperf(cp, y, test);
    end
    Accuracy = cp.CorrectRate;
    Precision = cp.PositivePredictiveValue;
    Recall = cp.Sensitivity;
end