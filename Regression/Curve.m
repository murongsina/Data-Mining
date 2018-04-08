function [ D ] = Curve( m, n, TaskNum )
%CURVE 此处显示有关此函数的摘要
%   此处显示详细说明

    D = cell(TaskNum, 1);
    for t = 1 : TaskNum
        Xt = rand(m, n);
        Wt = 20*t*rand(n, 1);
        Yt = Xt*Wt + (rand(m, 1)-0.5);
        D{t} = [Xt Yt];
    end
end