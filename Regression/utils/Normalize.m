function [ Xn, Yn ] = Normalize( X, Y )
%NORMALIZE 此处显示有关此函数的摘要
% 标准化多任务
%   此处显示详细说明

    [m, ~] = size(X);
    Xn = cell(m, 1);
    Yn = cell(m, 1);
    for t = 1 : m
        Xn{t} = zscore(X{t});
        Yn{t} = Y{t};
    end
end

