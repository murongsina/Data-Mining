function [ INDICES ] = CrossValInd( Y, Classes, Labels, k )
%CROSSVALIND 此处显示有关此函数的摘要
% 多分类数据集交叉验证索引
%   此处显示详细说明
% 参数：
%        Y    -数据集
%  Classes    -类别数
%   Labels    -标签列表
%        k    -交叉验证折数
% 输出：
%  INDICES    -交叉验证索引

    INDICES = zeros(size(Y));
    for i = 1 : Classes
        Yi = find(Y==Labels(i));
        indices = crossvalind('Kfold', Yi, k);
        INDICES(Yi) = indices;
    end
end