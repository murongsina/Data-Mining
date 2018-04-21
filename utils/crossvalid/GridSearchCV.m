function [ CVStat, CVTime ] = GridSearchCV( Learner, X, Y, IParams, TaskNum, Kfold, ValInd, opts )
%GRIDSEARCHCV 此处显示有关此函数的摘要
% 多任务的网格搜索交叉验证
%   此处显示详细说明

    solver = opts.solver;
    nParams = GetParamsCount(IParams);
    CVStat = zeros(nParams, 2*opts.IndexCount, TaskNum);
    CVTime = zeros(nParams, 2);
    
    fprintf('GridSearchCV: %d Params\n', nParams);
    for i = 1 : nParams
        fprintf('GridSearchCV: %d\n', i);
        Params = GetParams(IParams, i);
        Params.solver = solver;
        [CVStat(i,:,:), CVTime(i,:)]= CrossValid(Learner, X, Y, TaskNum, Kfold, ValInd, Params, opts);
    end
    
end
