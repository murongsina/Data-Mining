function [ Params ] = GetParams(root, index)
%GETPARAMS 此处显示有关此函数的摘要
%   此处显示详细说明
    names = fieldnames(root);
    [m, ~] = size(names);
    % 分解下标
    for i = 1 : m
        name = names{i};
        child = root.(name);
        wi = GetParamsCount(child);
        % 取得当前位的idx、得到高位num
        idx = mod(index-1, wi)+1;
        index = ceil(index / wi);
        % 访问子节点
        if isstruct(child)
            Params.(name) = GetParams(child, idx);
        else
            Params.(name) = child(idx, :);
        end
    end
end