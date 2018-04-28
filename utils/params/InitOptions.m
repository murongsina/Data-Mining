function [ opts ] = InitOptions( name, mean, solver)
%INITOPIONS 此处显示有关此函数的摘要
%   此处显示详细说明

    switch name
        case 'reg'
            opts.Mean = mean;
            opts.Statistics = @RegStat;
            opts.IndexCount = 4;
            opts.solver = solver;
            opts.Find = @min;
        case 'clf'
            opts.Mean = mean;
            opts.Statistics = @ClfStat;
            opts.IndexCount = 1;
            opts.solver = solver;
            opts.Find = @max;
        case 'mcl'
            opts.Mean = mean;
            opts.Mode = 'OvO';
            opts.Statistics = @ClfStat;
            opts.IndexCount = 1;
            opts.solver = solver;
            opts.Find = @max;
    end
end

