function [ chains ] = ENNC( X, Y, k, alpha, beta )
%ENNC 此处显示有关此函数的摘要
%   Extended Nearest Neighbor Chain (ENNC)
%   alpha    -反向收敛因子 
%   beta     -正向收敛因子 M[1,2] <= beta * M[0,1]
%   此处显示详细说明
    % 得到维数
    [m, ~] = size(X);
    % 得到距离
    M = DIST(X);
    % 筛选样本
%     samples = zeros(m, 1);
    % 对每一个样例x，得到ENNC
    chains = cell(m, 1);
    vis = zeros(m);
    for x = 1 : m
        nc = KNN_D(Y, M, x, k);
        % 如果没有不同类的近邻
        if ISEMPTY(nc)
            % 样本远离决策平面，设为-1
            vis(x) = -1;
            % 最近邻链为空
            chains{x} = [];
        else            
            % 迭代扩展最近邻链
            j0 = x;
            j1 = nc(1);
            nc = KNN_D(Y, M, j1, k);
            % 如果j1最近异类邻不为空
            chain = j0;
            while ISEMPTY(nc) == 0
                % Property 1; alpha = 3*beta
                if M(j0, j1) > alpha*M(j1,nc(1))
                    % j0远离决策平面
                    vis(j0) = -1;
                end
                % 收敛的很厉害，就退出; beta < 1
                % Property 2
                if beta * M(j0, j1) < M(j1, nc(1))
                    nc = KNN_D(Y, M, j1, k);
                    if ISEMPTY(nc) == 0
                        chain = [chain j1];                            
                        j0 = j1;
                        j1 = nc(1);
                        nc = KNN_D(Y, M, j1, k);                        
                    end
                end
            end
            % 保存最近邻链
            chains{x} = chain;
        end
    end
end

