function [ Output ] = GridSearchCV( Learner, X, Y, IParams, opts )
%GRIDSEARCHCV 此处显示有关此函数的摘要
% 多任务的网格搜索交叉验证
%   此处显示详细说明
% 参数：
%    Learner    -学习器
%          X    -样本
%          Y    -标签
%     Params    -参数网格
%      Kfold    -K折交叉验证
% 输出：
%     Output    -网格搜索、交叉验证结果

    TaskNum = opts.TaskNum;
    Kfold = opts.Kfold;
    ValInd = opts.ValInd;

    nParams = length(IParams);
    Output = zeros(nParams, 4);
    for i = 1 : nParams
        fprintf('GridSearchCV: %d', i);
        Params = IParams(i);
        for j = 1 : Kfold
            fprintf('CrossValid: %d', j);
            test = (ValInd == j);
            train = ~test;
            MTL_TrainTest
%             [ y, Time ] = Learner(X(train,:), Y(train,:), X(test,:), Params);
%             [ Stat ]  = Wrapper(Learner, TaskNum, X(train,:), Y(train,:), xTest, yTest, Params);
        end
    end
    
%% Statistics
    function [ XT, YT ] = MTL_TrainTest(X, Y, TaskNum, ValInd, Kfold)
        XT = cell(TaskNum, 1);
        YT = cell(TaskNum, 1);
        for ii = 1 : TaskNum
            Xt = X{t};
            Yt = Y{t};
            Vt = ValInd{t};
            XT{ii} = Xt(Vt==Kfold);
            YT{ii} = Yt(Vt==Kfold);
        end
    end

    function [ Stat ]  = Wrapper(Learner, TaskNum, xTrain, yTrain, xTest, yTest, Params)
        Stats = {@mae, @mse, @sae, @sse}
        [ y, Time ] = Learner(xTrain, yTrain, xTest, Params);
        Stat = zeros(TaskNum, 4);
        for ii = 1 : TaskNum
            for jj = 1 : 4
                Func = Stats{jj};
                Stat(ii, jj) = Func(y{i}-yTest{i}, y{i}, yTest{i});
            end
        end
    end
end