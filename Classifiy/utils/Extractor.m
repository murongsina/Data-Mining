function [ idx ] = Extractor( X, Y, k )
%EXTRACTOR 此处显示有关此函数的摘要
% 特征选择
%   此处显示详细说明
    [m, n] = size(X);
    Yb = mean(Y);
    Ystd = std(Y);
    corr = size(n, 1);
    for i = 1 : n
        Xi = X(:,i);
        Xb = mean(Xi);
        corr(i) = sum((Xi-Xb)*(Y-Yb))/((m-1)*std(Xi)*Ystd);
    end
    [~, idx] = sort(corr, 'descend');
    idx = idx(1:k, :);
end
