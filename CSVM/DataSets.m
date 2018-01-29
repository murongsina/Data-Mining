function [ D ] = DataSets( name, n )
%DATASETS 此处显示有关此函数的摘要
%   此处显示详细说明
    switch(name)
        case {'Sine'}
            % 正弦数据集
            D = Sine(n);
        case {'Grid'}
            % 网格数据集
            D = Grid(n, 2, 2, 1);
        case {'Ring'}
            % 环状数据集
            D = Ring(n, 2, 2);
        otherwise
            % 默认环状数据集
            D = Ring(n, 2, 2);
    end
end

