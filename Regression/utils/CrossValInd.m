function [ INDICES ] = CrossValInd( N, K )
%CROSSVALIND 此处显示有关此函数的摘要
% 回归数据集交叉验证索引
%   此处显示详细说明
% 参数：
%        N    -样本数
%        K    -交叉验证折数
% 输出：
%  INDICES    -交叉验证索引

    INDICES = crossvalind('Kfold', N, K);
end