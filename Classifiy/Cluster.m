function [ C, V, T ] = Cluster( X, Y, name, k )
%CLUSTER 此处显示有关此函数的摘要
% 聚类算法
%   此处显示详细说明
% 参数：
%      X   -样本
%      Y   -样本标签
%   name   -聚类方法
%      k   -聚类簇数
% 输出：
%      C   -簇划分
%      V   -聚类中心
%      T   -运行时间

    tic;
    V = [];
    switch(name)
        case {'Initial'}
            [ C ] = Y;
        case {'KMeans'}
            [ C, V ] = KMeans( X, k );
        case {'LVQ'}
            [ C, V ] = LVQ( X, Y, k, 0.2, 2000 );
        case {'AGNES'}
            [ C ] = AGNES( X, k, 'min' );
        case {'BiKMeans'}
            [ C ] = BiKMeans( X, 32, k );
        case {'DP'}
            [ C, V ] = DP();
    end
    % 如果没有计算聚类中心
    if isempty(V)
        V = ClusterCenter(X, C);
    end
    T = toc;
end