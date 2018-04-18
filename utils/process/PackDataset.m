function [ DataSet ] = PackDataset( Name, Data, LabelColumn, Classes, Instances, Attributes, Citation, AttributeTypes  )
%PACKDATASET 此处显示有关此函数的摘要
% 打包数据集
%   此处显示详细说明

    d = struct('Name', Name);
    d.Data = Data;
    d.Output = LabelColumn;
    d.Classes = Classes;
    d.Instances = Instances;
    d.Attributes = Attributes;
    d.Citation = Citation;
    d.AttributeTypes = AttributeTypes;
    DataSet = d;
end