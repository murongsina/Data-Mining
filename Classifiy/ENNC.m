function [ chain ] = ENNC(X, x, vis)  
    % 得到维数
    [m, ~] = size(X);
    % 得到距离
    M = DIST(X);          
    % 迭代扩展最近邻链
    j0 = x;
    j1 = nc(1);
    nc = KNN_D(Y, M, j1, k);
    % 如果j1最近异类邻不为空
    chain = j0;
    while ISEMPTY(nc) == 0
        % Property 1;
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
        % 对每一个样例x，得到ENNC
        chains = cell(m, 1);
        vis = zeros(m);
        for x = 1 : m
            if vis(x) == 1
                continue;
            end
            nc = KNN_D(Y, M, x, k);
            % 如果没有不同类的近邻
            if ISEMPTY(nc)
                % 样本远离决策平面，设为-1
                vis(x) = -1;
                % 最近邻链为空
                chains{x} = [];
            else            
            end
        end
        % 保存最近邻链
        chains{x} = chain;
    end
end