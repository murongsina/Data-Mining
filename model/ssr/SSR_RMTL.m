function [ CVStat, CVTime, CVRate ] = SSR_RMTL( xTrain, yTrain, xTest, yTest, TaskNum, IParams, opts )
%SSR_RMTL 此处显示有关此函数的摘要
% Safe Screening for RMTL
%   此处显示详细说明

%% Fit
tic;
[ X, Y, T, ~ ] = GetAllData(xTrain, yTrain, TaskNum);
n = GetParamsCount(IParams);
CVStat = zeros(n, 2*opts.IndexCount, TaskNum);
CVTime = zeros(n, 2);
CVRate = zeros(n, 1);
Alpha = cell(n, 1);
for i = 1 : n
    tic;
    Params = GetParams(IParams, i);
    [ H2 ] = GetHessian(X, Y, TaskNum, Params);
    if i == 1
        % solve the first problem
        [ H1, Alpha{1} ] = RMTL(H2);
    else
        % solve the rest problem
        [ H1, Alpha{i} ] = SSR_RMTL(H1, H2, Alpha{i-1});
    end
    CVTime(i, 1) = toc;
    [ y_hat, CVRate(i) ] = Predict(X, Y, xTest, Alpha{i}, Params);
    CVStat(i,:,:) = Statistics(TaskNum, y_hat, yTest, opts);
end

%% Statistics
    function [ OStat ] = Statistics(task_num, y_hat, yTest, opts) 
        Stat = MTLStatistics(task_num, y_hat, yTest, opts);
        OStat = [ Stat; zeros(size(Stat)) ];
    end

%% Predict
    function [ yTest, Rate ] = Predict(X, Y, xTest, Alpha, opts)
        % extract opts
        lambda1 = opts.lambda1;
        lambda2 = opts.lambda2;
        kernel = opts.kernel;
        task_num = length(xTest);
        mu = 1/(2*lambda2);
        nu = task_num/(2*lambda1);
        % predict
        yTest = cell(task_num, 1);
        for t = 1 : task_num
            Tt = T==t;
            Ht = Kernel(xTest{t}, X, kernel);
            y0 = mu*predict(Ht, Y, Alpha);
            yt = nu*predict(Ht(:,Tt), Y(Tt,:), Alpha(Tt,:));
            y = sign(mu*y0 + nu*yt);
            y(y==0) = 1;
            yTest{t} = y;
        end
        
        Rate = mean(Alpha==1|Alpha==0);
        
            function [ y ] = predict(H, Y, Alpha)
                svi = Alpha~=0;
                y = H(:,svi)*(Y(svi,:).*Alpha(svi,:));
            end
    end

%% RMTL
    function [ H1, Alpha1 ] = RMTL(H1)
        % primal problem
        e = ones(size(H1, 1), 1);
        lb = zeros(size(H1, 1), 1);
        [ Alpha1 ] = quadprog(H1, -e, [], [], [], [], lb, e, [], []);
    end

%% SSR-RMTL
    function [ H2, Alpha2 ] = SSR_RMTL(H1, H2, Alpha1)
        % safe screening rules
        P = chol(H2, 'upper');
        L = 1/2*(H1+H2)*Alpha1;
        R = norm(P\H1*Alpha1+P*Alpha1);
        Alpha2 = zeros(size(Alpha1));
        m = size(Alpha1, 1);
        for k = 1 : m
            Ri = norm(P(:,k))*R;
            if L(k) - Ri > 1
                Alpha2(k) = 0;
            elseif L(k) + Ri < 1
                Alpha2(k) = 1;
            else
                Alpha2(k) = -1;
            end
        end
        
        % reduced problem
        R = find(Alpha2 == -1);
        S = find(Alpha2 ~= -1);
        if ~isempty(R)
            f = 2*H2(R,S)*Alpha2(S)-1;
            lb = zeros(size(f));
            ub = ones(size(f));
            [ Alpha2(R) ] = quadprog(H2(R,R), f, [], [], [], [], lb, ub, [], []);
        end
    end

%% Get Hessian
    function [ H ] = GetHessian(X, Y, TaskNum, opts)
    % construct hessian matrix
        lambda1 = opts.lambda1;
        lambda2 = opts.lambda2;
        kernel = opts.kernel;
        mu = 1/(2*lambda2);
        nu = TaskNum/(2*lambda1);
        Q = Y.*Kernel(X, X, kernel).*Y';
        P = sparse(0, 0);
        for t = 1 : TaskNum
            Tt = T==t;
            P = blkdiag(P, Q(Tt,Tt));
        end
        H = Cond(mu*Q + nu*P);
    end


end