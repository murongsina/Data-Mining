function [ Params ] = CreateParams(root)
%CREATEPARAMS 此处显示有关此类的摘要
% 构造网格参数表
%   此处显示详细说明
    
    nParams = GetParamsCount(root);
    Params = repmat(GetParams(root, 1), nParams, 1);
    for index = 2 : nParams
        Params(index) = GetParams(root, index);
    end
    
    function [ Count ] = GetPropertyCount(root)
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
    function [ Count ] = GetParamsCount(root)
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
    function [ Params ] = GetParams(root, index)
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
    
end