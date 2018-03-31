function [ Results ] = CrossValid( Learner, X, Y, Params, opts )
%CROSSVALID 此处显示有关此函数的摘要
% k折交叉验证
%   此处显示详细说明
% 参数：
%  Learner    -学习算法
%        X    -样本
%        Y    -标签
%   Params    -学习器参数
%     opts    -交叉验证参数
% 输出：
%     
%     Time    -平均训练时间


%% Cross Validation
    Times = zeros(1, Kfold);
    Stats = zeros(Kfold, 4);
    Results = 
    Output = mean(Stats);
    Time = mean(Times);
end