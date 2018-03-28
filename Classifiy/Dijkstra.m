function [ distance, path ] = Dijkstra( D, start )
%DIJKSTRA 此处显示有关此函数的摘要
%   此处显示详细说明

    [m, ~] = size(D);
    % initialize.
    distance = D(start, :);
    path = repmat(start, 1, m);
    visited = zeros(1, m);
    % start search.
    visited(start) = 1;
    for i = 1 : m
        % 找离起点最近的未访问点
        uids = find(visited==0);
        [min_d, id] = min(distance(uids));
        mid = uids(id);
        % 标记mid已访问
        visited(mid) = 1;
        % 对未访问的，因为mid减少了距离的mids点，修改距离和路径
        for k = 1 : m
            d = min_d + D(mid, k);
            if visited(k) == 0 && d < distance(k)
                distance(k) = d;
                path(k) = mid;
            end
        end
    end
end