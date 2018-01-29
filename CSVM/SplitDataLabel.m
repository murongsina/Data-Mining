function [ X, Y ] = SplitDataLabel( D )
%SPLITDATALABEL 此处显示有关此函数的摘要
% 分割样本和标签
%   此处显示详细说明
    [~, n] = size(D);
    X = D(:, 1:n-1);
    Y = D(:, n);
end