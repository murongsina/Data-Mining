function [ D ] = Preprocess( DataSet )
%PREPROCESS 此处显示有关此函数的摘要
% 预处理数据集
%   此处显示详细说明

    Data = DataSet.Data;
    [m, n] = size(Data);
    D = zeros(m, n);
    if istable(Data)
        VariableNames = Data.Properties.VariableNames;
        for i = 1 : n
            % 取出来的Col是cell类型
            Col = Data{:, VariableNames{i}};                
            if iscell(Col)
                % 离散属性
                Classes = unique(Col);
                for j = 1 : length(Classes)                   
                    D(strcmp(Col, Classes{j}), i) = j;
                end
            elseif ismatrix(Col)
                % 连续属性
                D(:, i) = Col;
            else
                throw(MException('Preprocess:Table', 'Unrecognized column type'));
            end
        end
    elseif iscell(Data)
        throw(MException('Preprocess:Cell', 'Unsupported type'));
    elseif ismatrix(Data)
        D = Data;
    end
end