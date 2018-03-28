function [ Xd, Yd ] = DSSM( X, Y, dc )
%DSSM 此处显示有关此函数的摘要
% Distance-based Sample Selection Method
%   此处显示详细说明
% 参数：
%      X    -数据集
%      Y    -标签集
%     dc    -选择比例

    Xp = X(Y==1,:); Xn = X(Y==-1,:);
    Yp = Y(Y==1,:); Yn = Y(Y==-1,:);
    [p, ~] = size(Xp); [q, ~] = size(Xn);
    % 1: calculate the distance between samples from different classes
    D = zeros(q, p);
    for i = 1 : q
        for j = 1 : p
            D(i, j) = norm(Xn(i,:)-Xp(j,:));
        end
    end
    % 2: sort dij in D in ascending order, record its' index i,j
    [Da, IX] = sort(D(:));
    [R, C]=ind2sub(size(D), IX);
    E = [R C Da];
    % 3:
    Edc = E(1:dc,:);
    % 4:
    Ddc = Da(dc);
    fP = zeros(p, 1); fN = zeros(q, 1);
    for i = 1 : p
        % for positive points, exists dij <= dc
        if isempty(find(Edc(:,2)==i & Edc(:,3)<=Ddc, 1)) == 0
            fP(i) = 1;
        end
    end
    for i = 1 : q
        % for negative points, exists dij <= dc
        if isempty(find(Edc(:,1)==i & Edc(:,3)<=Ddc, 1)) == 0
            fN(i) = 1;
        end
    end
    Xd = [Xp(fP==1,:); Xn(fN==1,:)];
    Yd = [Yp(fP==1,:); Yn(fN==1,:)];
end