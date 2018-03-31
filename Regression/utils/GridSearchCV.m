function [ Output ] = GridSearchCV( Learner, X, Y, IParams, opts )
%GRIDSEARCHCV 此处显示有关此函数的摘要
% 网格搜索交叉验证
%   此处显示详细说明
% 参数：
%    Learner    -学习器
%          X    -样本
%          Y    -标签
%     Params    -参数网格
%      Kfold    -K折交叉验证
% 输出：
%     Output    -网格搜索、交叉验证结果
    
%% Parse opts
    if isfield(opts, 'Kfold')
        Kfold = opts.Kfold;
    else
        throw(MException('CrossValid', 'No Kfold'));
    end
    if isfield(opts, 'ValInd')
        ValInd = opts.ValInd;
    else
        throw(MException('CrossValid', 'No ValInd'));
    end
    
%% Gride Search and Cross Validation
    nParams = length(IParams);
    Output = zeros(nParams, 4);
    for i = 1 : nParams
        fprintf('GridSearchCV: %d', i);
        for j = 1 : Kfold
            fprintf('CrossValid: %d', j);
            test = (ValInd == j);
            train = ~test;
            [ y, Time ] = Learner(X(train,:), Y(train,:), X(test,:), Params);
        end
    end
end