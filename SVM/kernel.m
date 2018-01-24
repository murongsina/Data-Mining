function [ H ] = kernel( ker, U, V )
%KERNEL 此处显示有关此函数的摘要
%   此处显示详细说明

    [ru, ~] = size(U);
    [rv, ~] = size(V);
    H = zeros(ru, rv);
    for i = 1 : ru
        for j = 1 : rv
            H(i, j) = svkernel(ker, U(i,:), V(j,:));
        end
    end
end