function [ yTest, Time ] = TWSVR_Xu( xTrain, yTrain, xTest, opts )
%TWSVR_XU 此处显示有关此函数的摘要
% Twin Support Vector Machine
% Xu's model
%   此处显示详细说明

%% Parse opts
    C1 = opts.C1;
    C2 = opts.C2;
    eps1 = opts.eps1;
    eps2 = opts.eps2;
    kernel = opts.kernel;
    solver = opts.solver;

%% Fit
    tic;
    % 得到H
    e = ones(size(yTrain));
    C = xTrain;
    Y = yTrain;
    G = [Kernel(xTrain, C, kernel) e];
    GG = G'*G;
    GG = Utils.Cond(GG);
    GGG = GG\G';
    H = G*GGG;
    HTY = H'*Y;
    % 求解两个二次规划
    [m, ~] = size(yTrain);
    e = ones(m, 1);
    lb = zeros(m, 1);
    % TWSVR1
    ub1 = e*C1;
    Alpha = quadprog(H,(Y+eps1)-HTY,[],[],[],[],lb,ub1,[],solver);
    % TWSVR2
    ub2 = e*C2;
    Gamma = quadprog(H,HTY-(Y-eps2),[],[],[],[],lb,ub2,[],solver);
    % 得到u,v
    u = GGG*(Y-Alpha);
    v = GGG*(Y+Gamma);
    % 得到w
    w = (u+v)/2;
    % 停止计时
    Time = toc;
    
%% Predict
    [m, ~] = size(xTest);
    e = ones(m, 1);
    yTest = [Kernel(xTest, C, kernel), e]*w;
    
end
