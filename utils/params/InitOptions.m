function [ opts ] = InitOptions( name, mean, solver, hasfig)
%INITOPIONS 此处显示有关此函数的摘要
%   此处显示详细说明

    switch name
        case 'reg'
            opts.Mean = mean;
            opts.Statistics = @RegStat;
            opts.IndexCount = 4;
            opts.solver = solver;
            opts.hasfig = hasfig;
            opts.Find = @min;
            opts.Indices = {'MAE', 'RMSE', 'SSE/SST', 'SSR/SSE'};
        case 'clf'
            opts.Mean = mean;
            opts.Statistics = @ClfStat;
            opts.IndexCount = 4;
            opts.solver = solver;
            opts.hasfig = hasfig;
            opts.Find = @max;
            opts.Indices = {'Accuracy', 'Precision', 'Recall', 'F1'};
        case 'mcl'
            opts.Mean = mean;
            opts.Mode = 'OvO';
            opts.Statistics = @ClfStat;
            opts.IndexCount = 4;
            opts.solver = solver;
            opts.hasfig = hasfig;
            opts.Find = @max;
            opts.Indices = {'Accuracy', 'Precision', 'Recall', 'F1'};
    end
end

