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
    nParams = GetParamsCount(IParams);
    CVStat = zeros(nParams, 4, TaskNum);
    % 网格搜索
    for i = 1 : nParams
        fprintf('GridSearchCV: %d\n', i);
        % 设置参数
        Params = GetParams(IParams, i);
        Params.solver = solver;
        % 交叉验证
        CVStat(i,:,:) = CrossValid(Learner, X, Y, TaskNum, Kfold, ValInd, Params);
    end
    Stat = GSStatistics(TaskNum, CVStat);
    
%% 多任务网格搜索统计
    function [ OStat ] = GSStatistics(TaskNum, IStat)
        OStat = zeros(4, TaskNum, 2);
        [ MIN, IDX ] = min(IStat);
        OStat(:,:,1) = MIN(1,:,:);
        OStat(:,:,2) = IDX(1,:,:);
        OStat = permute(OStat, [2 1 3]);
    end

end