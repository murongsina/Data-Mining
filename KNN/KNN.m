function [ Label ] = KNN( X, Y, x, k )
%KNN 此处显示有关此函数的摘要
%  K Nearest Neighbours
%
%    Usage: [ Label ] = KNN( X, Y, x, k )
%
%    Parameters: X     -Training inputs
%                Y     -Training targets
%                x     -Test input
%                k     -Neighbours count k
%
%   此处显示详细说明

    [m, ~] = size(X);
    xs = repmat(x, m, 1);
    % 1. 计算已知类别数据集合汇总的点与当前点的距离
    dist = (sum((xs - X).^2, 2)).^0.5;
    % 2. 按照距离递增排序
    [B, IX] = sort(dist, 'ascend');
    % 3. 选取与当前点距离最近的k个点
    len = min(k, length(B));
    % 4. 选取距离最近k个点中出现次数最多的类别作为预测分类
    Label = mode(Y(IX(1:len)));
end
