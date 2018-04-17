function [ yTest, Time ] = MultiClf(xTrain, yTrain, xTest, opts)
%MULTICLF 此处显示有关此类的摘要
% Multi-Classifier
%   此处显示详细说明

%% Parse opts
    Classes = opts.Classes;     % 分类数
    Labels = opts.Labels;       % 真实标签
    Params = opts.Params;       % 学习器参数 
    
    %% 基学习器
    try
       BaseLearner = str2func(Params.Name);
    catch Exception
        throw(MException('MultiClf', 'unresolved function:%s', Params.Name));
    end
    
    %% 训练模式
    Mode = opts.Mode;           % 模式：OvO, OvR
    switch (Mode)
        case {'OvO'}
            Learner = @MultiOvO;
        case {'OvR'}
            Learner = @MultiOvR;
        otherwise
            throw(MException('MultiClf', [ 'Mode "', Node, '" undefined']));
    end
    
    %% 开始学习
    [ yTest, Time ] = Learner(BaseLearner, xTrain, yTrain, xTest, Params);

%% Multi-OvO
function [ yTest, Time ] = MultiOvO(Learner, xTrain, yTrain, xTest, opts)
    tic;
    
    [m, ~] = size(xTest);
    YTests = zeros(m, m*(m+1)/2);

    nIndex = 0;
    for i = 1 : Classes - 1
        for j = i + 1 : Classes
            nIndex = nIndex + 1;
            [ XTrain, YTrain ] = OvO(xTrain, yTrain, Labels, i, j);
            [ YTest, ~ ] = Learner(XTrain, YTrain, xTest, opts);
            YTest(YTest==1) = i;
            YTest(YTest==-1) = j;
            YTests(:, nIndex) = YTest;
        end
    end

    Time = toc;
    
    yTest = zeros(m, 1);
    yVote = zeros(1, Classes);
    for i = 1 : m
        for j = 1 : Classes
            yVote(1, j) = sum(YTests(i, :) == j);
        end
        [~, IDX] = sort(yVote(1, :), 'descend');
        yTest(i) = Labels(IDX(1));
    end
end

%% Multi-OvR
function [ yTest, Time ] = MultiOvR(Learner, xTrain, yTrain, xTest, opts)
    tic;
    % 多分类
    yTest = zeros(m, 1);
    for i = 1 : Classes
        % OvR分割数据集
        [ XTrain, YTrain ] = OvR(xTrain, yTrain, Labels, i);
        % 训练和预测
        [ YTest, ~ ] = Learner(XTrain, YTrain, xTest, opts);
        % 对正类点赋值
        yTest(YTest==1) = Labels(i);
    end
    Time = toc;
end

%% One vs One
    function [ Xr, Yr ] = OvO( X, Y, Lables, i, j )
        %OvO 此处显示有关此函数的摘要
        % i作为正类点，j负类点
        %   此处显示详细说明

        Ip = Y==Lables(i);
        In = Y==Lables(j);
        Xp = X(Ip, :);
        Yp = ones(length(Xp), 1);
        Xn = X(In, :);
        Yn = -ones(length(Xn), 1);
        Xr = [Xp; Xn];
        Yr = [Yp; Yn];
    end

%% One vs Rest
    function [ Xr, Yr ] = OvR( X, Y, Lables, i)
        %OvO 此处显示有关此函数的摘要
        % i作为正类点，其余负类点
        %   此处显示详细说明
        
        Ip = Y==Lables(i);
        In = Y~=Lables(i);
        Xp = X(Ip, :);
        Yp = ones(length(Xp), 1);
        Xn = X(In, :);
        Yn = -ones(length(Xn), 1);
        Xr = [Xp; Xn];
        Yr = [Yp; Yn];
    end

end