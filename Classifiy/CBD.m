function [ Xr, Yr ] = CBD( X, Y, k, s, rate )
%CBD 此处显示有关此函数的摘要
% Concept Boundary Detection
%   此处显示详细说明
% 参数：
%    X    -数据集
%    Y    -标签
%    k    -近邻数
%    s    -策略
%            1：贡献总Score得分G前rate比例的样本
%            2：样本Score排名前rate比例的样本
%    rate -比例

    [m, ~] = size(X);
    % 得到距离
    D = DIST(X);
    % Determine exponential decay paprameter Gamma.
    Gamma = 0;
    Tau = zeros(m, 1);
    Counter = 0;
    for i = 1 : m
        nonf = 0;
        knn = KNN(D, i, k);
        for j = 1 : k
            if Y(i) ~= Y(knn(j))
                % 记录异类最近邻的距离Tau(i)
                if nonf == 0
                    nonf = 1;
                    Tau(i) = D(i, knn(j));
                end
                % 对于每个异类最近邻，都减去Tau(i);
                Gamma = Gamma + D(i, knn(j)) - Tau(i);
                Counter = Counter + 1;
            end
        end
    end
    Gamma = Gamma / Counter;
    % Determine the scores of instances
    Score = zeros(m, 1);
    Sharp = zeros(m, 1);
    for i = 1 : m
        nonf = 0;
        knn = KNN(D, i, k);
        for j = 1 : k
            if Y(i) ~= Y(knn(j))
                if nonf == 0
                    nonf = 1;
                    Tau(i) = D(i, knn(j));
                end
                Score(knn(j)) = Score(knn(j)) + exp(-(D(i, knn(j))-Tau(i))/Gamma);
                Sharp(knn(j)) = Sharp(knn(j)) + 1;
            end
        end
    end
    for i = 1 : m
        if Sharp(i) ~= 0
            Score(i) = Score(i) / Sharp(i);
        end
    end
    % Having obtained the scores of instances in the dataset, we now need to 
    % prune out instances based on their scores. We outline two strategies 
    % for the choice of the number of instances.
    [ScoreA, IX] = sort(Score, 'descend');
    if s == 2
        % We first obtain the sum, G, of the sorted scores of all instances in the dataset
        G = sum(ScoreA); Gr = G * rate; Gs = 0;
        % Then, starting with the instance with the highest score, we keep 
        % picking instances till the sum of the scores of selected instances 
        % is within a pre-specified percentage of G, the goal being to select instances 
        % contributing significantly to the overall score.
        i = 1;
        while Gs < Gr
            Gs = Gs + ScoreA(i);
            i = i + 1;
        end
        idx = IX(1:i, :);
    else
        % The first strategy leaves the choice of the number of instances
        % to be chosen with the user. Given the computational resources available, 
        % a user may choose the number of instances that form the subset.
        % The actual instances are then chosen by picking the required number 
        % of instances with the highest scores.
        idx = IX(1:m*rate,:);
    end
    Xr = X(idx,:); Yr = Y(idx,:);
end