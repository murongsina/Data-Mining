function [  ] = SCATTER( X )
%SCATTER 此处显示有关此函数的摘要
% 绘制散点图
%   此处显示详细说明
    Xn = X(X(:,3)==-1,:);
    scatter(Xn(:,1),Xn(:,2),12,'xr');
    hold on;
    Xp = X(X(:,3)==1,:);
    scatter(Xp(:,1),Xp(:,2),12,'+g');
end