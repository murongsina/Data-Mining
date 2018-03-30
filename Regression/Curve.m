function [ D ] = Curve( m, TaskNum )
%CURVE 此处显示有关此函数的摘要
%   此处显示详细说明

    D = cell(TaskNum, 1);
    for t = 1 : TaskNum
        Xt = (1:9/m:10)';
        Wt = 2*t*ones(1, 1);
        Yt = 12 - 2*t + Xt*Wt + (rand(m+1, 1)-0.5);
        D{t} = [Xt Yt];
    end
end