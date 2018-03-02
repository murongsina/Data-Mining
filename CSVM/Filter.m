function [ Dr, T ] = Filter( D, ssm )
%FILTER 此处显示有关此函数的摘要
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
            % 1. Neighbors Property Pattern Selection
            % Spiral distributed dataset
            [Xr, Yr] = NPPS(X, Y, 12);
        case {'NDP'}
            % 2. Neighbour Distribution Pattern
            % However, some reserved samples far away from decision plane have
            % no contribution to the performance of SVM and should be disposed
            [Xr, Yr] = NDP(X, Y, 18, 9, 9);
        case {'FNSSS'}
            % 3. Fixed Neighborhood Sphere Sample Selection (FNSSS)
            [Xr, Yr] = FNSSS(X, Y, 1, 300);
        case {'DSSM'}
            % 4. Distance-based Sample Selection Method
            [Xr, Yr] = DSSM(X, Y, 300);
        case {'KSSM'}
            % 5. Knn-based Sample Selection Method
            [Xr, Yr] = KSSM(X, Y, 8);
        case {'CBD'}
            % 6. Concept Boundary Detection
            % Spiral distributed dataset
            [Xr, Yr] = CBD(X, Y, 12, 2, 0.95);
        case {'MCIS'}
            % 7. Multi-Class Instance Selection
            % ref: Fast instance selection for speeding up support vector machines
            [Xr, Yr] = MCIS(X, Y, 2, 0.5);
        case {'BEPS'}
            % 8. Border-Edge Pattern Selection
            % ref: Selecting critical patterns based on local geometrical and statistical information
        case {'NSCP'}
            % 9. 不稳定分割点样本选择
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