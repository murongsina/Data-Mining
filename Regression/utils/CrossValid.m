function [ Stats, Time ] = CrossValid( Learner, X, Y, k, ValInd, Params )
%CROSSVALID 此处显示有关此函数的摘要
% k折交叉验证
%   此处显示详细说明
% 参数：
%  Learner    -学习算法
%        D    -数据集
%        k    -k折交叉验证
%   ValInd    -交叉验证索引
% 输出：
%      MAE    -平均绝对误差
%     RMSE    -均方根误差
%  SSE/SST    -
%  SSR/SSE    -
%     Time    -平均训练时间

    % 训练时间
    Times = zeros(1, k);
    Stats = zeros(k, 1);
    % 实验记进行k次(交叉验证折数)，求k次的平均值作为实验结果
    for i = 1 : k
        fprintf('CrossValid: %d', i);
        % 得到训练和测试集索引
        test = (ValInd == i);
        train = ~test;
        % 训练和预测
        [ y, Time ] = Learner(X(train,:), Y(train,:), X(test,:), Params);
        % 记录时间
        yTest = Y(test,:);
        Times(1, i) = Time;
        Stats(i, 1) = mse(y-yTest, yTest, y);
        Stats(i, 2) = mae(y-yTest, yTest, y);
        Stats(i, 3) = sse(y-yTest, yTest, y);
        Stats(i, 4) = sae(y-yTest, yTest, y);
    end
end