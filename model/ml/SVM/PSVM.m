function  [ yTest, Time, w ] = PSVM( xTrain, yTrain, xTest, opts )
%PSVM 此处显示有关此函数的摘要
% proximal support vector machine
%   此处显示详细说明

    nu = opts.nu;
    
    [m, n] = size(xTrain);
    e = ones(m, 1);
    D = diag(yTrain);
    H = D*[A -e];
    r = sum(H)';
    r = Cond(speye(n+1)/nu + H'*H)\r; % solve (I/nu+H'*H)r=H'*e;
    u = nu*(1-H*r); s = D*u;
    w = (s'*A)';    % w=A'*D*u
    gamma = -sum(s);    % gamma=-e'*D*u
    w = [w;gamma];
end

