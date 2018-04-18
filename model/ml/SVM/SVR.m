function [ yTest, Time, W ] = SVR( xTrain, yTrain, xTest, opts )
%SVR 此处显示有关此函数的摘要
% Support Vector Regression
%   此处显示详细说明

    C = opts.C;
    eps = opts.eps;
    kernel = opts.kernel;
    solver = opts.solver;
    
%% Fit
    tic;
    A = xTrain;
    Y = yTrain;
    K = Kernel(A, A, kernel);
    H = [K -K;-K K];
    f = [-Y;Y]+eps;
    e = ones(size(Y));
    Aeq = [e;-e]';
    beq = 0;
    lb = zeros(size(f));
    ub = C*ones(size(f));
    Beta = quadprog(H,f,[],[],Aeq,beq,lb,ub,[],solver);
    n = length(Y);
    Alpha = reshape(Beta, n, 2);
    alpha = Alpha(:,2)-Alpha(:,1);
    % Support Vectors
    svi = Alpha > 1e-5 & Alpha < C-1e-5;
    sv = svi(:,1)|svi(:,2);
    % calculate w
    w = alpha(sv,:);
    % calculate b
    b = yTrain(sv,:)-K(sv,sv)*w;
    if sum(sv) == 0
        b = 0;
    else
        b = mean(b);
    end
    W = [w; b];
    Time = toc;
    
%% Predict
    yTest = Kernel(xTest, A(sv,:), kernel)*w + b;
    
end