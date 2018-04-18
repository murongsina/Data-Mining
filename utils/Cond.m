function [ A ] = Cond( H )
%COND 此处显示有关此函数的摘要
% 调整核矩阵
%   此处显示详细说明
% 参数：
%     H     -核矩阵
%     A     -调整后矩阵

    A = H + 1e-5*eye(size(H));
end