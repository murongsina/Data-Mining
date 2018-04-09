function [ OStat ] = Statistic( IStat )
%STATISTIC 此处显示有关此函数的摘要
% 统计实验数据
%   此处显示详细说明

    [m, n] = size(IStat);
    OStat;
    % 对每一个数据集
    for i = 1 : m
        % 对每一个算法
        for j = 1 : n
            AStat = IStat{i, j};
            Stat = AStat{1, 4};
            % 对每一个任务
            for t = 1 : TaskNum
                OStat(:,j,i) = Stat(:,:,t);
            end
        end        
    end
    
end

