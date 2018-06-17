function [ Y ] = PCA(X, n)
%PCA 此处显示有关此函数的摘要
%   此处显示详细说明
    [coeff, score, latent] = pca(X);
    Y = X*coeff;
end