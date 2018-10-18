function [ CVStat, CVTime ] = GridSearchCV( Learner, X, Y, IParams, TaskNum, Kfold, ValInd, opts )
%GRIDSEARCHCV 此处显示有关此函数的摘要
% 多任务的网格搜索交叉验证
%   此处显示详细说明
 
    % 初始化参数
    solver = opts.solver;
    nParams = GetParamsCount(IParams);
    CVStat = zeros(nParams, 2*opts.IndexCount, TaskNum);
    CVTime = zeros(nParams, 2);
    % 加载检查点
    if isfile('check-point.mat')
        load('check-point.mat', 'CVStat', 'CVTime', 'Index');
        start = Index;
        fprintf('GridSearchCV: load check-point, start at %d\n', start);
    else
        start = 1;
    end
    % 开始网格搜索
    fprintf('GridSearchCV: %d Params\n', nParams);
    for i = start : nParams
        fprintf('GridSearchCV: %d\n', i);
        Params = GetParams(IParams, i);
        Params.solver = solver;
        [CVStat(i,:,:), CVTime(i,:)]= CrossValid(Learner, X, Y, TaskNum, Kfold, ValInd, Params, opts);
        if mod(i, 400) == 0
            Index = i + 1;
            save('check-point.mat', 'CVStat', 'CVTime', 'Index');
        end
    end
    delete('check-point.mat');
end