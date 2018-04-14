function [ OStat, OTime, CVStat ] = GridSearchCV( Learner, X, Y, IParams, TaskNum, Kfold, ValInd, opts )
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

    solver = opts.solver;
    nParams = GetParamsCount(IParams);
    CVStat = zeros(nParams, 8, TaskNum);
    CVTime = zeros(nParams, 2);
    
    fprintf('GridSearchCV: %d Params\n', nParams);
    for i = 1 : nParams
        fprintf('GridSearchCV: %d\n', i);
        Params = GetParams(IParams, i);
        Params.solver = solver;
        [CVStat(i,:,:), CVTime(i,:)]= CrossValid(Learner, X, Y, TaskNum, Kfold, ValInd, Params);
    end
    
    [ OStat, OTime ] = GSStatistics(TaskNum, CVStat, CVTime);
end
