function [ Xr, Yr, W ] = LDP( X, Y, k, rate )
%LDP 此处显示有关此函数的摘要
% Local Density Peaks Sample Selection
%   此处显示详细说明
% 参数：
%      X    -数据集
%      Y    -标签
%      n    -样本数
%      k    -簇数
%    Rho    -筛选比例

    % 对样本进行密度峰值聚类
    [ C, ~, Rho, ~, ~, ~, ~, ~, ~, ~ ] = DP( X, k );
    [m, ~] = size(X);
    W = zeros(m, 1);
    for c = 1 : k
        % 找出同类点
        ids = find(C==c);
        % 选取局部密度范围rate以下的点
        rho = Rho(ids);
        rho_cut = min(rho) + range(rho)*rate;
        retain = ids(rho < rho_cut);
        W(retain) = Rho(retain);
    end
    % 得到被选中样本点的下标
    WP = W > 0;
    Xr = X(WP, :); Yr = Y(WP, :);
end