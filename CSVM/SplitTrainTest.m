function [ DTrain, DTest ] = SplitTrainTest( D, k )
%SPLITTRAINTEST 此处显示有关此函数的摘要
% 随机按比例分割训练集和测试集
%   此处显示详细说明
% 参数：
%     D    -数据集
%     k    -训练集比例
% 返回：
%    DTrain   -训练集
%     DTest   -测试集

    [m, ~] = size(D);
    n = ceil(m*k);
    indices = randperm(m);
    DTrain = D(indices(1:n), :);
    DTest = D(indices(n+1:m), :);
end