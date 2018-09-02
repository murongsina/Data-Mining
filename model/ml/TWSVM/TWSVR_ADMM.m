function [ yTest, Time ] = TWSVR_ADMM( xTrain, yTrain, xTest, opts )
% TWSVR_ADMM 此处显示有关此函数的摘要
% Trace-Norm Regularization with Least Squares Loss (Least Trace)
%   此处显示详细说明

MAX_ITER = 400;

rho1 = opts.rho1;
rho2 = opts.rho2;
lambda1 = opts.lambda1;
lambda2 = opts.lambda2;
f = yTrain + eps2;
g = yTrain - eps1;
[ ~, u ] = ADMM(xTrain, f, g, C1, rho1, @MTL_TWSVC1);
[ ~, v ] = ADMM(xTrain, f, g, C2, rho2, @MTL_TWSVC2);

%% ADMM
function [ obj, W ] = ADMM(A, B, C, rho, objective)
    for k = 1 : MAX_ITER
        % x-update
        % z-update with relaxation
        z = Shrinkage(u + x, rho);
        % u-update
        u = u + x - z;
        % 目标值和解
        obj = objective(A, B, z, C, rho);
        W = x;
        % 记录求解过程
        history.obj(k) = obj;
        history.x(k) = x;
        history.z(k) = z;
        history.r_norm(k) = norm(x - z);
    end
end
%% Soft Thresholding
function [ Z ] = Shrinkage(X, K)
    Z = max(0, X-K)-max(0, -X-K);
end

%% MTL-TWSVC1
function [ obj, grad ] = MTL_TWSVC1(A, B, U, C1, rho1)
    obj_s = cell(T, 1);
    grad_s = cell(T, 1);
    for t = 1 : T
        [ obj_h, grad_h ] = HingeLoss(max(0, e2+B{t}*U{t}), B{t});
    end
end

%% MTL-TWSVC2
function [ obj, grad ] = MTL_TWSVC2(A, B, V, C2, rho2)
    obj = 0.5*norm(B*V, 2)^2 - C2*norm(1-A*V, 2)^2 + rho2*norm(V, 1);
end

%% Hinge Loss
function [ obj, grad ] = HingeLoss(F, X)
    obj = zeros(size(F(1,:)));
    grad = zeros(size(X(1,:)));
    for i = 1 : N
        if F(i) < 1
            obj = obj+ F(i);
            grad = grad + X;
        end
    end
end

end