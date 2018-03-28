function [ IDX ] = MST_KNN( M, idx, L )
%MST_KNN 此处显示有关此函数的摘要
%
%   计算MST中相关点的L阶近邻，也即L次传递闭包
%   此处显示详细说明
%
%   M      -邻接矩阵
%   idx    -MST中的相关点下标
%   L      -阶数
%   IDX    -L阶近邻的下标
    [m, ~] = size(idx);
    L1 = zeros(m, 1);
    T = M^(L+1);
    for i = 1 : m
        % T中第i行值大于L的列标记为1
        L1(T(idx(i, 1), :)>L, 1) = 1;
    end
    IDX = find(L1==1);
end

