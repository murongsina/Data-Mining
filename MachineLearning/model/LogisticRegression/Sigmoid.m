function [ Y ] = Sigmoid( X )
%SIGMOID 此处显示有关此函数的摘要
%   此处显示详细说明

    Y = 1.0 ./ (1 + exp(-X));
end

