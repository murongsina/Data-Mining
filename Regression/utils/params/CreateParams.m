function [ Params ] = CreateParams(root)
%CREATEPARAMS 此处显示有关此类的摘要
% 构造网格参数表
%   此处显示详细说明
    
    nParams = GetParamsCount(root);
    Params = repmat(GetParams(root, 1), nParams, 1);
    for index = 2 : nParams
        Params(index) = GetParams(root, index);
    end
    
    
end