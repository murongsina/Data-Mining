function [ Stat, CVStat ] = GridSearchCV( Learner, X, Y, IParams, TaskNum, Kfold, ValInd, opts )
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
    nParams = length(IParams);
    CVStat = zeros(nParams, 4, TaskNum);
    % 网格搜索
    for i = 1 : nParams
        fprintf('GridSearchCV: %d\n', i);
        % 设置参数
        Params = IParams(i);
        Params.solver = solver;
        % 交叉验证
        CVStat(i,:,:) = CrossValid(Learner, X, Y, TaskNum, Kfold, ValInd, Params);
    end
    Stat = CVStatistics(TaskNum, CVStat);
    
    function [ OStat ] = CVStatistics(TaskNum, IStat)
        % 交叉验证统计每一个任务
        OStat = zeros(TaskNum, 4, 2);
        for t = 1 : TaskNum
            [V, I] = min(IStat(:,:,t));
            OStat(t,:,:) = [V, I];
        end
    end
end