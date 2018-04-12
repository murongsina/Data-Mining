function [ U, V ] = MTL_AGO_TWSVC( X, Y, opts )
%MTL_AGO_TWSVC 此处显示有关此函数的摘要
%   此处显示详细说明

    % 初始化参数
    C1 = opts.C1;
    C2 = opts.C2;
    rho1 = opts.rho1;
    rho2 = opts.rho2;
    TaskNum = opts.TaskNum;
    
    % 初始化数据集
    [ A, B ] = SplitData(X, Y, TaskNum);
    [ U ] = AGO(A, B, C1, rho1, @MTL_TWSVC1, @MTL_TWSVC1_GRAD);
    [ V ] = AGO(B, A, C2, rho2, @MTL_TWSVC2, @MTL_TWSVC2_GRAD);
    
%% Split Data
    function [ A, B ] = SplitData(X, Y, TaskNum)
        A = cell(TaskNum, 1);
        B = cell(TaskNum, 1);
        for t = 1 : TaskNum
            Xt = X{t};
            Yt = Y{t};
            A{t} = Xt(Yt==1,:);
            B{t} = Xt(Yt==-1,:);
        end
    end
        
%% Accelerated Gradient Descent
    function [ obj ] = AGO(A, B, C, rho, FuncEval, GradEval)
        f = FuncEval(A, B, obj, C, rho);
        g = GradEval(A, B, obj, C, rho);
    end

%% Soft Thresholding
    function [ L, TN ] = Shrinkage(X, alpha)
        % Z = max(0, X-K)-max(0, -X-K);
        [ u,s,v ] = svd(X);
        s = diag(s) - alpha/2;
        S = s.*(s>0);
        L = u*diag(S)*v';
        TN = sum(S);
    end

%% MTL-TWSVC1
    function [ obj ] = MTL_TWSVC1(A, B, U, C1, rho1)
        obj = 0.5*norm(A*U, 2)^2 + C1*norm(1+B*U, 2)^2 + rho1*norm(U, 'fro')^2;
    end

    function [ var ] = MTL_TWSVC1_GRAD(A, B, U, C1, rho1)
        I = ones(size(B));
        var = (A'*A+B'*I)\(-2*B'*I);
    end

%% MTL-TWSVC2
    function [ obj ] = MTL_TWSVC2(A, B, V, C2, rho2)
        obj = 0.5*norm(B*V, 2)^2 - C2*norm(1-A*V, 2)^2 + rho2*norm(V, 'fro')^2;
    end

    function [ var ] = MTL_TWSVC2_GRAD(A, B, V, C2, rho2)
    end
end