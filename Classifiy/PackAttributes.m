function [ AttributeTypes ] = PackAttributes( n, Real, Integer, Categorical )
%PACKATTRIBUTES 此处显示有关此函数的摘要
% 构造属性类别
%   此处显示详细说明
% 参数：
%     n             -属性个数
%     Real          -连续属性
%     Integer       -整数属性
%     Categorical   -分类属性

    AttributeTypes = zeros(1, n);
    AttributeTypes(1, Real ) = 1;
    AttributeTypes(1, Integer) = 2;
    AttributeTypes(1, Categorical) = 3;
end