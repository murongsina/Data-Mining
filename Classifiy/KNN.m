function [ idx ] = KNN( M, x, k )
%KNN 此处显示有关此函数的摘要
%   此处显示详细说明
    [~, idx] = sort(M(x,:), 'ascend');
    idx = idx(:,2:1+k);
end