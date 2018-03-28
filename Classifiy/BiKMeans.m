function [ S ] = BiKMeans( X, m, k )
%BIKMEANS 此处显示有关此函数的摘要
% 二分k均值聚类
%   此处显示详细说明
% 参数：
%    X    -数据集
%    m    -二分次数
%    k    -目标簇数
% 输出：
%    S    -簇集
%

    [n, ~] = size(X);
    % Step 1: 初始化簇集S，只包含一个所有样本的簇，将簇数k'初始化为1；
    S = ones(n, 1);
    k1 = 1;
    while k1 < k
        % Step 2: 从S中取出一个最大的簇Ni；
        hist = histc(S, 1: k1);
        [~, ix] = max(hist);
        Ni = X(S==ix, :);
        % 最优簇划分
        BestC = zeros(length(Ni), 1);
        SSE = Inf;
        for i = 1 : m
            % Step 3: 使用k-均值聚类算法对簇Ni进行m次二分聚类操作；
            [C, V] = KMeans(Ni, 2);
            % Step 4: 分别计算这m对子簇的总SSE大小；
            sse = 0;
            for j = 1 : 2
                NV = Ni(C==j, :) - V(j);
                EV = sum(NV.*NV, 2);
                sse = sse + sum(EV);
            end
            % Step 4: 找出总SSE最小的簇划分；
            if sse < SSE
                SSE = sse;
                BestC = C;
            end
        end
        % Step 4: 将具有最小总SSE的一对子簇添加到S中；
        fprintf('Split: C%d -> C%d + C%d\n', ix, k1 + 1, ix);
        BestC(BestC==2) = k1 + 1; % 其中一个簇设为k1 + 1；
        BestC(BestC==1) = ix; % 另一个簇保持原始编号；
        S(S==ix) = BestC; % S中所有ix类分割为新簇
        % Step 4: 执行k'++操作；
        k1 = k1 + 1;
    % Step 5: 如果k'=k，算法结束，否则重复Step 2 - Step 5。
    end
end