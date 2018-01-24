function [ H ] = Entropy( D )
%ENTROPY 此处显示有关此函数的摘要
%    Properties: D        -数据列表
%                H        -数据集在每一个列上的熵
%   此处显示详细说明
    [m, n] = size(D);
    fprintf('size of D = [%d, %d]\n', m, n);
    % 初始熵
    H = zeros(1, n);    
    % 对每一个特征
    for i = 1 : n
        % 找出特征的所有取值
        PropertySet = unique(D(:, i));
        [u, ~] = size(PropertySet);
        % 初始化概率
        P = zeros(1, u);
        % 对特征中的每一个取值
        for j = 1 : u
            % 计算特征每一个取值出现的概率
            if class(PropertySet(j,:)) == 'cell'
                P(:, j) = length(find(strcmp(D(:, i), PropertySet(j, :)))) / m;
            else
                P(:, j) = length(find(D(:, i)==PropertySet(j, :))) / m;
            end
        end
        fprintf('sum of Pj: %d\n', sum(P));
        H(:, i) = -sum(P.*log2(P));        
    end
end

