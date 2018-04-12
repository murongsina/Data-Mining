function [ Y ] = Kernel(U, V, opts)
%KERNEL 此处显示有关此类的摘要
% 核函数
%   此处显示详细说明
% 参数：
%     U    -矩阵U
%     V    -矩阵V
%  opts    -核函数参数

    % Parse opts
    p1 = opts.p1;
    % Kernel
    Y = exp(-(repmat(sum(U.*U,2)',m,1)+repmat(sum(V.*V,2),1,m1) - 2*V*U')/(2*p1^2));
    Y = Y';

end