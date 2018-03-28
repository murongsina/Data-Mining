function [ C ] = AGNES( X, k, d )
%AGNES 此处显示有关此函数的摘要
% AGNES 层次聚类算法
%   此处显示详细说明
% 参数：
%    X   -数据集
%    k   -聚类簇数
% 输出：
%    C   -簇划分
%

    [m, ~] = size(X);
    % 初始化单样本聚类簇
    C = (1:m)';
    % 初始化距离矩阵
    M = DIST(X);
    D = M;
    % 设置当前聚类簇个数
    q = m;
    while q > k
        % 找到距离最近两个簇
        dist = min(M(M~=0));
        idx = find(M==dist);
        [r, c] = ind2sub(size(M), idx(1));
        i = min([r c]);
        j = max([r c]);
        % 合并Ci和Cj
        C(C==j) = i;
        % 将聚类簇C_{j}重新编号为C_{j-1}
        C(C>j) = C(C>j)-1;
        % 删除距离矩阵的第j行与第j列
        M(j, :) = [];
        M(:, j) = [];
        q = q - 1;
        % 重新计算簇i到簇j的距离
        for j = 1 : q
            % 得到簇i与簇j的距离
            Mij = D(C==i, C==j);
            switch(d)
                case {'min'}
                % 1. 单连接法
                M(i, j) = min(Mij(:));
                case {'max'}
                % 2. 全连接法
                M(i, j) = max(Mij(:));
                case {'avg'}
                % 3. 平均连接法
                M(i, j) = mean(Mij(:));
            end
            M(j, i) = M(i, j);
        end
    end
end