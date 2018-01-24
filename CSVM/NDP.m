function [ D ] = NDP( X, Y, k, th_p, th_n )
%CSSUM 此处显示有关此函数的摘要
% Cosine Sum Sample Selection
%
% 参数：
%   X     -数据集
%   Y     -标签集
%   k     -近邻数
%   th_p  -正类点余弦和阈值
%   th_n  -负类点余弦和阈值
%
%   此处显示详细说明
    % Generating Dp'
    Dp = X(Y==1,:);
    idp = NDP_PART(Dp, k, th_p);
    Dp1 = Dp(idp,:);
    % Generating Dn'
    Dn = X(Y==-1,:);
    idn = NDP_PART(Dn, k, th_n);
    Dn1 = Dn(idn,:);
    % Generating D'
    % Step 6: use Dp' and Dn' to construct D';
    D = [Dp1; Dn1];
end

