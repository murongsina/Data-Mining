function [ DataSet ] = PackDataset( Name, Data, Label, Classes, Instances, Attributes, Citation  )
%PACKDATASET 此处显示有关此函数的摘要
%   此处显示详细说明

    d = struct('Name', Name);
    d.Data = Data;
    d.Label = Label;
    d.Classes = Classes;
    d.Instances = Instances;
    d.Attributes = Attributes;
    d.Citation = Citation;    
    DataSet = d;
end