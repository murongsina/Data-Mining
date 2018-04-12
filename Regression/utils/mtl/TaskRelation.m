function [ S ] = TaskRalation( X )
%TASKRALATION 此处显示有关此函数的摘要
%   此处显示详细说明

    [m, ~] = size(X);
    S = zeros(m, m);
    for i = 1 : m
        for j = 1 : m
            Xi = X(i,:);
            Xj = X(j,:);
            S(i, j) = (Xi*Xj')/(norm(Xi)*norm(Xj));
        end
    end
    
end