function [ Dr, T ] = SSMWrapper( D, ssm )
%SSMWraper 此处显示有关此函数的摘要
% Sample Selection Method Wrapper
%   此处显示详细说明
% 参数：
%     ssm    -样本选择算法
%       D    -数据集
%

    % 分割样本和标签
    [X, Y] = SplitDataLabel(D);
    % 开始计时
    tic;
    % 选择算法
    switch(ssm)
        case {'NPPS'}
            % 最近邻属性模式选择
            [Xr, Yr] = NPPS(X, Y, 16);
        case {'NDP'}
            % 余弦和模式选择
            [Xr, Yr] = NDP(X, Y, 24, 12, 12);
        case {'FNSSS'}
            % 固定近邻球样本选择
            [Xr, Yr] = FNSSS(X, Y, 1, 800);
        case {'DSSM'}
            % 基于距离的样本选择方法
            [Xr, Yr] = DSSM(X, Y, 800);
        case {'KSSM'}
            % 基于k近邻的样本选择
            [Xr, Yr] = KSSM(X, Y, 6);
        case {'NSCP'}
            % 不稳定分割点样本选择
            [Xr, Yr] = NSCP(X, Y, 1);
        case {'ALL'}
            % 全部样本
            Xr = X; Yr = Y;
        otherwise
            Xr = X; Yr = Y;
    end
    % 停止计时
    T = toc;
    % 合并样本和标签
    Dr = [Xr, Yr];
end