function [ delta, Delta ] = GeodesicLines( d, m, i, ids )
%GEODESICLINES 此处显示有关此函数的摘要
% 计算测地线距离
%   此处显示详细说明
% 参数：
%     d     -距离矩阵
%     m     -mKNN graph
%     i     -start point.
%   ids     -id of other points

    [ dG, ~ ] = Dijkstra( m, i );
    [ dist, idx ] = min(dG(ids));
    if dist < Inf
        % When 'i' can find its nearest neighbour on a reachable path in the
        % mKNN graph. calculate 'distance' and 'index' according to (9).
        delta = dist;
        Delta = ids(idx);
    else
        % When we have disconnected components in the mKNN graph, a point
        % can not find its nearest neighbour on a reachable path in the
        % mKNN graph. So a compromise is made that the 'index' is still set 
        % as the original one with the smallest L2 distance.
        [~, idx] = min(d(i, ids));
        Delta = ids(idx);
        % 'k' is the nearest point to 'index' in the reachable point set of
        % 'i'. calculate 'k' according to (10).
        l = find(dG < Inf);
        [~, idx] = min(d(l, Delta));
        k = l(idx);
        % calculate distance according to (10).
        delta = dG(k) + d(k, Delta);
    end
end