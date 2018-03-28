function [ C ] = MergeStruct( A, B )
%MERGESTRUCT 此处显示有关此函数的摘要
% 合并结构体
%   此处显示详细说明

    namesa = fieldnames(A);
    namesb = fieldnames(B);
    for i = 1 : length(namesa)
        C.(namesa{i}) = A.(namesa{i});
    end
    for i = 1 : length(namesb)
        C.(namesb{i}) = B.(namesb{i});
    end
end