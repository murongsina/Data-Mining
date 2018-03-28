function [ idx ] = KNN_D( Y, M, x, k )
%KNN_D 此处显示有关此函数的摘要
% 最近异类邻居  
% 参数：
%   Y    -标签列表
%   M    -距离矩阵
%   x    -样本编号
%   k    -近邻数目
%   此处显示详细说明
    % 找出k近邻
    knn = KNN(M, x, k);
    % 找出第一个不同类的近邻
    idx = find(Y(knn)~=Y(x));
end

