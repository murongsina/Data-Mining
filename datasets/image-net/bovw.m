function [ X ] = bovw( IDX, count, k )
%BOVW 此处显示有关此函数的摘要
% Bag of Visual Word
%   此处显示详细说明

    n = size(count, 1);
    X = sparse(n, k);
    u = 1;
    for i = 1 : n
        % 第i组u,v
        v = u + count(i) - 1;
        tab = tabulate(IDX(u:v,:));
        cnt = tab(:,2)>0;
        idx = tab(cnt,1);
        fre = tab(cnt,3);
        X(i,idx) = fre;
        % 下一组
        u = u + count(i);
    end
end

