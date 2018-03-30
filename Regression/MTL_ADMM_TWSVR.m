function [ U, V ] = MTL_ADMM_TWSVR( X, Y, Dims, TaskNum, C1, C2, rho1, rho2 )
%MTL_ADMM_TWSVR 此处显示有关此函数的摘要
% Trace-Norm Regularization with Least Squares Loss (Least Trace)
%   此处显示详细说明

    MAX_ITER = 400;
    
    A = X(Y==1,:);
    B = Y(Y==-1,:);
    
    [ ~, U ] = ADMM(A, B, C1, rho1, @MTL_TWSVC1);
    [ ~, V ] = ADMM(A, B, C2, rho2, @MTL_TWSVC2);

%% ADMM
    function [ obj, W ] = ADMM(A, B, C, rho, objective)
        x = zeros(Dims, TaskNum);
        z = zeros(Dims, TaskNum);
        y = zeros(Dims, TaskNum);
        
        AtA = A'*A;
        BtB = B'*B;
        I = ones(Dims, TaskNum);
        for k = 1 : MAX_ITER
            % x-update
            % dL/dx == 0
            x = (AtA + BtB + rho)\(rho*z - y - B'*I);
            % z-update with relaxation
            % dL/dz == 0
            z = Shrinkage(y + x, rho);
            % u-update
            y = y + (x-z);
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
    function [ obj ] = MTL_TWSVC1(A, B, U, C1, rho1)
        obj = 0.5*norm(A*U, 2)^2 + C1*norm(1+B*U, 2)^2 + rho1*norm(U, 1);
    end

%% MTL-TWSVC2
    function [ obj ] = MTL_TWSVC2(A, B, V, C2, rho2)
        obj = 0.5*norm(B*V, 2)^2 - C2*norm(1-A*V, 2)^2 + rho2*norm(V, 1);
    end

%% Hinge Loss
    function [ var ] = HingeLoss()
        
    end

end