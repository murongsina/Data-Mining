function [ Xr, Yr ] = MCIS( X, Y, k, r )
%MCIS 此处显示有关此函数的摘要
% Multi-Class Instance Selection
%   此处显示详细说明
% 参数：
%    X   -数据集
%    Y   -标签集
%    k   -聚类数
%    r   -保留比例
    
    [N, ~] = size(X);
    C = unique(Y);
    L = length(C);
    S = ones(N, 1);
    % 1. 对每一个分类
    for i = 1 : L
        % 2. 对每一个c类点
        Sc = X(Y==C(i), :); Nc = length(Sc);         
        % 3. 在c类点上进行k均值聚类，得到k个聚类中心
        [ ~, M ] = KMeans( Sc, k );
        [ Mx, ~ ] = SplitDataLabel(M); 
        % 4. 对每一个聚类中心Mi
        for j = 1 : k
            % 5. 计算x到聚类中心Mi的距离
            vx = X - Mx(j, :);
            D = sqrt(sum(vx.*vx, 2));
            [~, ix] = sort(D, 'ascend');
            % 6. 如果 Nc >= r*N/3 + k
            if Nc >= (r*N/3 + k)
                ncb = (Nc - r*N/3)/k;                
                % 7. 移除c类点靠近聚类中心的ncb个点
                for u = 1 : N
                    if Y(ix(u)) == C(i)
                        ncb = ncb - 1;
                        if ncb == 0
                            S(ix(u)) = 1;
                        end
                    end
                end
            end
            if Nc >= (r*N/3 + k)
                nc = r*N/3;
            else
                nc = Nc;
            end
            nl = (r*N - nc)/(k*(L-1));
            % 9. 选出靠近聚类中心的nl个不属于c类的点
            for u = 1 : N
                if Y(ix(u)) ~= C(i)
                    nl = nl - 1;
                    S(ix(u)) = 1;
                    if nl == 0
                        break;
                    end
                end
            end
        end
    end
    Xr = X(S==1, :); Yr = Y(S==1, :);
end