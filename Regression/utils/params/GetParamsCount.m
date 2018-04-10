function [ Count ] = GetParamsCount(root)
%GETPARAMSCOUNT 此处显示有关此函数的摘要
%   此处显示详细说明
    % 获取所有参数的组合数
    Count = 1;
    if isstruct(root)
        names = fieldnames(root);
        [m, ~] = size(names);
        for i = 1 : m
            child = root.(names{i});
            x = GetParamsCount(child);
            Count = Count * x;
        end
    else
        [m, ~] = size(root);
        Count = Count * m;
    end
end
