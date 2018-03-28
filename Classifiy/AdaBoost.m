classdef AdaBoost
    %ADABOOST 此处显示有关此类的摘要
    % AdaBoost.M1
    %   此处显示详细说明
    
    properties (Access = 'public')
        Name; % 分类器名称
        M;    % 基分类器数目
    end
    
    properties (Access = 'private')
        Clfs;  % 基分类器数组
        Alpha; % 分类器权重
    end
    
    methods (Access = 'public')
        function [ clf ] = AdaBoost(Clfs)
            clf.Name = 'ADABOOST';
            clf.M = length(Clfs);
            clf.Clfs = Clfs;
            clf.Alpha = ones(clf.M, 1)/clf.M;
        end
        function [ clf, Time ] = Fit(clf, xTrain, yTrain)
            % 计时
            tic
            % AdaBoost
            [m, ~] = size(xTrain);
            % 初始化训练数据的权值分布
            W = ones(m, 1)/m;
            % 对m = 1,2,...,M
            for i = 1 : clf.M
                Clf = clf.Clfs{i};
                % 使用具有权值分布Dm的的训练数据集学习，得到基本分类器
                Clf = Clf.Fit(xTrain, yTrain);
                % 保存分类器i
                clf.Clfs{i} = Clf;
                % 计算Gm在训练数据集上的分类误差率
                yPred = Clf.Predict(xTrain);
                % 加权标准化错误率
                Error = sum(W(yPred~=yTrain))/sum(W);
                % 计算Gm的系数
                clf.Alpha(i) = 0.5*log((1-Error)/Error);
                % 更新训练数据集的权值分布
                W = W*exp(-clf.Alpha(i)*(yTrain~=yPred));
            end
            % 停止计时
            Time = toc;
        end
        function [ yTest ] = Predict(clf, xTest)
            [m, ~] = size(xTest);
            % 保存每个分类器预测结果
            yPred = zeros(m, clf.M);
            % 每一个二分类器都做一次预测
            for i = 1 : clf.M
                Clf = clf.Clfs(i);
                yPred(:, i) = Clf.Predict(xTest);
            end
            % 构建基本分类器的线性组合，得到最终分类器
            yTest = sign(yPred*clf.Alpha);
        end
        function disp(clf)
            fprintf('%s: M=%d\n', clf.Name, clf.M);
        end
    end
end