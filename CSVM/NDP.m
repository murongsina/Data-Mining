function [ dX, dY ] = NDP( X, Y, k, th_p, th_n )
%CSSUM 此处显示有关此函数的摘要
% Cosine Sum Sample Selection
%   此处显示详细说明
% 参数：
%   X     -数据集
%   Y     -标签集
%   k     -近邻数
%   th_p  -正类点余弦和阈值
%   th_n  -负类点余弦和阈值

    % Generating Dp'
    [Xp1, Yp1] = NDP_PART(X(Y==1,:), Y(Y==1,:), k, th_p);
    % Generating Dn'
    [Xn1, Yn1] = NDP_PART(X(Y==-1,:), Y(Y==-1,:), k, th_n);
    % Generating D'
    % Step 6: use Dp' and Dn' to construct D';
    dX = [Xp1; Xn1]; dY = [Yp1; Yn1];
end
