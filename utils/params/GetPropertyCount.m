function [ Count ] = GetPropertyCount(root)
%GETPROPERTYCOUNT 此处显示有关此函数的摘要
%   此处显示详细说明
    % 得到叶节点数目
    Count = 0;
    if isstruct(root)
        names = fieldnames(root);
        [m, ~] = size(names);
        for i = 1 : m
            SubParamTree = root.(names{i});
            Count = Count + GetPropertyCount(SubParamTree);
        end
    else
        Count = 1;
    end
end
