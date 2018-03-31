function [ Output, Time ] = CrossValid( Learner, X, Y, Kfold, ValInd, Params, opts )
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

%     Stats = { 'MSE', 'MAE', 'SSE', 'SAE' };
    Funcs = { @mse, @mae, @sse, @sae };
    
    % 训练时间
    Times = zeros(1, Kfold);
    Stats = zeros(Kfold, 4);
    % 实验记进行k次(交叉验证折数)，求k次的平均值作为实验结果
    for i = 1 : Kfold
        fprintf('CrossValid: %d', i);
        % 得到训练和测试集索引
        test = (ValInd == i);
        train = ~test;
        % 训练和预测
        opts.Params = Params;
        [ y, Time ] = Learner(X(train,:), Y(train,:), X(test,:), opts);
        % 记录时间
        Times(1, i) = Time;
        % 统计指标
        yTest = Y(test,:);
        for j = 1 : 4
            Stats(i, j) = Funcs{j}(y-yTest, yTest, y);
        end
    end
    Output = mean(Stats);
    Time = mean(Times);
end