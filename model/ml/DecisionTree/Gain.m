function [ GDA ] = Gain( D )
%GAIN 此处显示有关此函数的摘要
%    Parameters: D      -数据集D
%                A     -特征A
%
%
%   此处显示详细说明
    % 得到数据集大小
    [~, n] = size(D);
    % 计算集合在每一个特征的熵H(D)
    HD = Entropy(D);
    % 计算集合在每一个特征的条件熵H(D|A)
    HDA = zeros(1, n);
    for i = 1 : n
        % 找出特征的所有取值
        PropertySet = unique(D(:, i));
        [u, ~] = size(PropertySet);
        % 计算每一个特征的条件熵
        for j = 1 : u
            % 得到该取值上的样本子集
            Dj = D(D(:, i)==PropertySet(j,:),:);
            [x, ~] = size(Dj);
            % 计算该样本子集的熵
            Ent = Entropy(Dj);
            % 累计条件熵
            HDA = HDA + (x/u)*Ent;
        end
    end
    GDA = HD - HDA;    % Gain(D, A)
end

