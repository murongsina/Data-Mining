function [ Y ] = Kernel(tstX, X, opts)
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
    [ m, ~ ] = size(X);
    [ n, ~ ] = size(tstX);
    Y = exp(-(repmat(sum(tstX.*tstX,2)',m,1)+repmat(sum(X.*X,2),1,n) - 2*X*tstX')/(2*p1^2));
    Y = Y';

end