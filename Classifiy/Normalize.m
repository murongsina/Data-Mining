function [ D ] = Normalize( Data, LabelColumn )
%NOMALIZE 此处显示有关此函数的摘要
% 归一化，标准化样本
%   此处显示详细说明

    [X, Y] = SplitDataLabel(Data, LabelColumn);
    [m, n] = size(X);
    Xn = zeros(m, n);
    for i = 1 : n
        Xi = X(:, i);
        Xn(:, i) = (Xi - mean(Xi))./std(Xi);
        % Xn(:, i) = mapminmax(Xi);
    end
    D = [Xn, Y];
end

