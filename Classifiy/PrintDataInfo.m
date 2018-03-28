function [  ] = PrintDataInfo( DataSets )
%PRINTDATAINFO 此处显示有关此函数的摘要
% 打印数据集信息
%   此处显示详细说明

    nDataSet = length(DataSets);
    fprintf('Name & Instances & Attributes & Classes \\\n');
    for i = 1 : nDataSet
        D = DataSets(i);
        fprintf('%s & %d & %d & %d \\\n', D.Name, D.Instances, D.Attributes, D.Classes);
    end
end