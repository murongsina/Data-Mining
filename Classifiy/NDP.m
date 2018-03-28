function [ Xr, Yr, W ] = NDP( X, Y, k, th_p, th_n )
%NDP 此处显示有关此函数的摘要
% Neighbour Distribution Pattern
%   此处显示详细说明
% 参数：
%   X     -数据集
%   Y     -标签集
%   k     -近邻数
%   th_p  -正类点余弦和阈值
%   th_n  -负类点余弦和阈值

    % Generating Dp'
    [Xp, Yp, Wp] = NDP_PART(X(Y==1,:), Y(Y==1,:), k, th_p);
    % Generating Dn'
    [Xn, Yn, Wn] = NDP_PART(X(Y==-1,:), Y(Y==-1,:), k, th_n);
    % Generating D'
    % Step 6: use Dp' and Dn' to construct D';
    Xr = [Xp; Xn]; Yr = [Yp; Yn]; W = [Wp; Wn];
end