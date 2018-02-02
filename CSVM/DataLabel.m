function [ Dr ] = DataLabel( D, j )
%DATALABEL 此处显示有关此函数的摘要
% 将标签放最后一列
%   此处显示详细说明
% 参数：
%    D   -数据集
%    j   -标签所在列

    [ X, Y ] = SplitDataLabel( D, j );
    Dr = [X, Y];
end