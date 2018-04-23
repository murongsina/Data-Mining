function [ opts ] = InitOptions( name, solver)
%INITOPIONS 此处显示有关此函数的摘要
%   此处显示详细说明

    switch name
        case 'reg'
            opts.Statistics = @RegStat;
            opts.IndexCount = 4;
            opts.solver = solver;
        case 'clf'
            opts.Statistics = @ClfStat;
            opts.IndexCount = 1;
            opts.solver = solver;
        case 'mcl'
            opts.Mode = 'OvO';
            opts.Statistics = @ClfStat;
            opts.IndexCount = 1;
            opts.solver = solver;
    end
end

