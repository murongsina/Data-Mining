function [ Y ] = SMWInverse( D, U, Cinv, V )
%SMWINVERSE 此处显示有关此函数的摘要
% Sherman–Morrison–Woodbury formula
%   此处显示详细说明
    
    n = length(D);
    Dinv = [];
    for i = 1 : n
        Dinv = blkdiag(Dinv, inv(D{i}));
    end
    Dinv = sparse(Dinv);

    DinvU = Dinv*U;
    Y = Dinv-DinvU*(Cinv+V*Dinv*U)\DinvU';

end

