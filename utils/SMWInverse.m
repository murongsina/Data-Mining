function [ X ] = SMWInverse( A, P, rho )
%SMWINVERSE 此处显示有关此函数的摘要
% Sherman–Morrison–Woodbury formula
% $(A^TA+\frac{1}{\rho}*P)^{-1}$
%   此处显示详细说明
    
    n = length(P);
    Pinv = [];
    for i = 1 : n
        Pinv = blkdiag(Pinv, inv(P{i}));
    end
    I = eye(size(Pinv));
    H = I+rho*A*Pinv*A';
    X = rho*Pinv-rho^2*Pinv*A'*H\A*Pinv;
end

