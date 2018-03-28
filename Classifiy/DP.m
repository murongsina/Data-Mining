function [ C, V, Rho, Delta, Gamma, idx, DeltaTree, Halo, nCore, nHalo ] = DP( X, k )
%DP 此处显示有关此函数的摘要
% Density Peaks
%   此处显示详细说明
% 参数：
%          X    -数据集
%          k    -簇数
% 返回值：
%          C    -cluster assignment
%          V    -簇中心
%        Rho    -样本点局部密度
%      Delta    -距离样本点最近的较高密度点的局部密度
%      Gamma    -Rho*Delta
%        idx    -聚类中心
%  DeltaTree    -距离样本点最近的较高密度点
%       Halo    -簇Halo
%      nCore    -簇核心样本数
%      nHalo    -簇边缘样本数

    % 初始化簇划分
    [m, ~] = size(X);
    C = zeros(m, 1);
    % 计算距离矩阵
    d = DIST(X);
    % 选取前2%距离为dc
    du = triu(d); % 取上三角
    sdu = sort(du(:)); % 升序排列
    sdu = sdu(sdu > 0); % 大于0的距离
    l = m*(m-1)/2;
    rate = 0.02;
    dc = sdu(round(l*rate));
    % Basically, rho[i] is equal to the number of points that are closer than dc to point i.
    Rho = zeros(m, 1);
    for i = 1 : m
        j = setdiff(1 : m, i);
        di = d(i, j);
        % 1. Cut-off.
        Rho(i) = sum(di<dc);
        % 2. Guassian kernel.
        Rho(i) = sum(exp(-(di.*di)/(dc*dc)));
    end
    [~, rho_idx] = sort(Rho, 'descend');
    % delta[i] is measured by computing the minimum distance between the
    % point i and any other point with higher density
    Delta = zeros(m, 1);
    DeltaTree = zeros(m, 1);
    % Build Delta-Tree
    Peak = rho_idx(1);
    Delta(Peak) = max(d(Peak, :));
    DeltaTree(Peak) = Peak;
    for i = 2 : m
        % cluster center
        Peak = rho_idx(i);
        % find the nearest neighbour from the points with higher density 
        higher = rho_idx(1:i-1);
        [dist, idx] = min(d(Peak, higher));
        Delta(Peak) = dist;
        DeltaTree(Peak) = higher(idx);
    end
    % A hint for choosing the number of centers is provided by 
    % the plot of gamma = rho*delta sorted in decreasing order
    Gamma = Rho.*Delta;
    [ ~, gamma_idx ] = sort(Gamma, 'descend');
    idx = gamma_idx(1:k);
    % Hence, as anticipated, the only points of high delta and relatively high ρ
    % are the cluster centers.
    DeltaTree(idx) = idx;
    V = X(idx);
    % assignation
    C(idx) = (1:k).';
    for i = 1 : m
        u = rho_idx(i);
        % assign cluster label
        if C(u) == 0
            C(u) = C(DeltaTree(u));
        end
    end
    %halo
    Halo = C;
    if k > 1
        border_rho = zeros(k, 1);
        for i = 1 : m - 1
            u = C(i); % 得到i的簇划分
            for j = i + 1 : m
                v = C(j); % 得到j的簇划分
                % 距离小于dc的异类点i,j
                if u~=v && d(i,j)<=dc
                    % 两个异类点密度的平均值
                    rho_aver = (Rho(i) + Rho(j))/2.0;
                    % 找到C(i)类点边界密度最大平均值
                    if (rho_aver > border_rho(u)) 
                        border_rho(u) = rho_aver;
                    end
                    % 找到C(j)类点边界密度最大平均值
                    if (rho_aver > border_rho(v)) 
                        border_rho(v) = rho_aver;
                    end
                end
            end
        end
        % 对每一个样本
        for i = 1 : m
            % 如果密度小于所属类别边缘密度
            if Rho(i) < border_rho(C(i))
                % 则i不是halo
                Halo(i) = 0;
            end
        end
    end
    % core and halo statistics
    for i = 1 : k
        nCore = 0;
        nHalo = 0;
        for j = 1 : m
            if C(j) == i
                nCore = nCore + 1;
            end
            if Halo(j) == i
                nHalo = nHalo + 1;
            end
        end
    end
end