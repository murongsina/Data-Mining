function [ X, Y ] = SplitDataLabel( D, j )
%SPLITDATALABEL 此处显示有关此函数的摘要
% 分割样本和标签
%   此处显示详细说明
% 参数：
%    D    -数据集
%    j    -标签列，默认将最后一列作为标签
% 输出：
%    X    -样本
%    Y    -标签

    [~, n] = size(D);
    if (nargin < 2)
        X = D(:, 1:n-1);
        Y = D(:, n);
    elseif j < 1 || j > n
        help SplitDataLabel;
    else
        if j == 1
            X = D(:, 2:n);
        elseif j == n
            X = D(:, 1:n-1);
        else
            X = [D(:, 1:j-1), D(:, j+1:n)];
        end
        Y = D(:, j);
    end
end