function [ Xn, Yn ] = NSCP( X, Y, k )
%NSCP 此处显示有关此函数的摘要
% Non-Stable Cut Point Sample Selection [Decision Tree]
%   此处显示详细说明
% 参数：
%      X    -样本
%      Y    -标签
%      k    -选择参数

    [m, n] = size(X);
%     class = unique(Y);
%     nclass = length(class);
%     GATS = zeros(m-1, 1);
    % 筛选样本
    samples = zeros(m, n);
    for i = 1 : n
        % 在i属性上按升序进行排序
        [~, IX] = sort(X(:, i), 'ascend');        
        % 对每一个样本点计算判别函数
%         for j = 1 : m-1
%             S1 = IX(1:j); S2 = IX(j+1:m);            
%             P1 = 0; P2 = 0;
%             for c = 1 : nclass
%                 P1 = P1 + NSCP_Convex(length(find(Y(S1)==class(c)))/j);
%                 P2 = P2 + NSCP_Convex(length(find(Y(S2)==class(c)))/(m-j));
%             end
%             GATS(j) = j/m * P1 + (m-j)/m * P2;
%         end
        % stable point
        for j = 1 : m-1
            u = IX(j); v = IX(j+1);
            if Y(u) == Y(v)
                samples(u, i) = 0;
                samples(v, i) = 0;
            end
        end
        % non-stable point
        for j = 1 : m-1
            u = IX(j); v = IX(j+1);
            if Y(u) ~= Y(v)
                samples(u, i) = 1;
                samples(v, i) = 1;
            end
        end
        % 找到不稳定分割点所在的最小值
%         [Min, ~] = min(GATS);
        % 找到多个最小值，即多个不稳定分割点
%         NSCP = find(GATS == Min <= 0.000001);
        % 不稳定分割点的下一个分割点，也是不稳定的
%         samples(IX(NSCP), i) = 1;
%         samples(IX(NSCP+1), i) = 1;
    end
    % 计算不稳定指数
    samples(:, 1) = sum(samples, 2);
    idx = find(samples(:,1) > k);
    % 得到约减后的数据集
    Xn = X(idx, :); Yn = Y(idx, :);
end
