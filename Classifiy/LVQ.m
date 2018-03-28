function [ C, V ] = LVQ( X, Y, k, alpha, MaxIter )
%LVQ 此处显示有关此函数的摘要
% 学习向量量化算法
%   此处显示详细说明
% 参数：
%    X   -数据集
%    Y   -标签
%    q   -原型向量个数
%    t   -原型向量预设类别标记
% 输出：
%    C   -簇划分
%    V   -聚类中心

    [m, n] = size(X);
    % 初始化一组原型向量
    Vx = rand(k, n);
    Vy = unique(Y);
    % 设置更新标记
    for Iter = 1 : MaxIter
        % 随机选取一个样本
        j = randperm(m, 1);
        % 计算样本到每个原型向量的距离
        PX = X(j) - Vx;
        D = sqrt(sum(PX.*PX, 2));
        % 找出与x最近的原型向量p
        [~, i] = min(D);
        % 如果x与p的类别相同
        if Y(j) == Vy(i)
            % p向x靠拢
            Vx(i, :) = Vx(i, :) + alpha * (X(j) - Vx(i, :));
        else
            % p远离x
            Vx(i, :) = Vx(i, :) - alpha * (X(j) - Vx(i, :));
        end
    end
    C = Y;
    V = [Vx, Vy];
end