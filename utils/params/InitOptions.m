function [ opts ] = InitOptions( name, mean, solver, hasfig, version)
%INITOPIONS 此处显示有关此函数的摘要
% 初始化参数
%   此处显示详细说明

    switch name
        case 'reg'
            opts.Mean = mean;
            opts.Statistics = @RegStat;
            opts.solver = solver;
            opts.hasfig = hasfig;
            opts.Find = @min;
            opts.Indices = {'MAE', 'RMSE', 'SSE/SST', 'SSR/SSE'};
        case 'clf'
            opts.Mean = mean;
            opts.Statistics = @ClfStat;
            opts.solver = solver;
            opts.hasfig = hasfig;
            opts.Find = @max;
            opts.Indices = {'Accuracy', 'Precision', 'Recall', 'F1'};
        case 'mcl'
            opts.Mean = mean;
            opts.Mode = 'OvO';
            opts.Statistics = @ClfStat;
            opts.solver = solver;
            opts.hasfig = hasfig;
            opts.Find = @max;
            opts.Indices = {'Accuracy', 'Precision', 'Recall', 'F1'};
    end
    
    if nargin > 4
        if version == 1
            % 第一版只统计了Accuracy
            opts.Indices = {'Accuracy'};
            opts.IndexCount = 2;
        end
        if version == 2
            % 第二版交换了Precision和Recall顺序
            opts.Indices = opts.Indices([1, 3, 2, 4]);
            opts.IndexCount = 8;
        end
        if version == 3
            % 第三版只统计了平均值，没有标准差
            opts.IndexCount = 4;
        end
    end
end