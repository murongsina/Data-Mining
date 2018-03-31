function [ D ] = Preprocess( DataSet )
%PREPROCESS 此处显示有关此函数的摘要
% 预处理数据集
%   此处显示详细说明

    Data = DataSet.Data;
    AttributeTypes = DataSet.AttributeTypes;
    [m, n] = size(Data);
    D = zeros(m, n);
    if istable(Data)
        VariableNames = Data.Properties.VariableNames;
        for i = 1 : n
            % 取出来的Col是cell类型
            Col = Data{:, VariableNames{i}};
            if AttributeTypes(i) == 1
                % Real
                D(:, i) = Col;
            elseif AttributeTypes(i) == 2
                % Integer
                D(:, i) = Col;
            elseif AttributeTypes(i) == 3
                % Categorical
                Classes = unique(Col);
                for j = 1 : length(Classes)                   
                    D(strcmp(Col, Classes{j}), i) = j;
                end
            else
                % 其他类型
                throw(MException('Preprocess:Table', 'Unrecognized column type'));
            end
        end
    elseif iscell(Data)
        throw(MException('Preprocess:Cell', 'Unsupported Data Type'));
    elseif ismatrix(Data)
        D = Data;
    end
end