classdef MultiClf
    %MULTICLF 此处显示有关此类的摘要
    % 构造多分类器
    %   此处显示详细说明

    properties (Access = 'public')
        Name;     % 分类器名称
        nClasses; % 多分类数
        Clfs;     % 分类器
        Lables;   % 类别数组
        Params;   % 分类器运行参数
    end

    methods (Access = 'public')
        function [ clf ] = MultiClf(Clf, nClasses, Labels)
            clf.Name = ['Multi-', Clf.Name];
            clf.nClasses = nClasses;
            clf.Clfs = repmat(Clf, nchoosek(nClasses, 2), 1);
            clf.Lables = Labels;
            clf.Params = struct(Clf);
        end
        function [ clf, Time ] = Fit(clf, xTrain, yTrain)
        %FIT 此处显示有关此函数的摘要
        % 训练
        %   此处显示详细说明
        % 参数：
        %     xTrain    -训练样本
        %     yTrain    -训练标签
        % 返回：
        %       Time    -训练时间

            % OvO分类
            nIndex = 0;
            % 开始计时
            tic;
            % 开始训练
            for i = 1 : clf.nClasses - 1
                for j = i + 1 : clf.nClasses
                    nIndex = nIndex + 1;
                    % 选取第nIndex个分类器
                    Clf = clf.Clfs(nIndex);
                    % 进行OvO分类
                    [ XTrain, YTrain ] = MultiClf.OvO(xTrain, yTrain, clf.Lables, i, j);
                    [ Clf, ~ ] = Clf.Fit(XTrain, YTrain);
                    % 保存分类器训练结果
                    clf.Clfs(nIndex) = Clf;
                end
            end
            % 停止计时
            Time = toc;
        end
        function [ yTest ] = Predict(clf, xTest)
        %PREDICT 此处显示有关此函数的摘要
        % 解决多分类问题
        % 参数：
        %     clf    -分类器
        %       X    -样本
        % 返回：
        %   yTest    -预测结果
            % 进行OvO分类预测
            [m, ~] = size(xTest);
            [n, ~] = size(clf.Clfs);
            % 分类矩阵
            YTests = zeros(m, n);
            % 进行OvO多分类
            nIndex = 0;
            for i = 1 : clf.nClasses - 1
                for j = i + 1 : clf.nClasses
                    nIndex = nIndex + 1;
                    % 选取第nIndex个分类器
                    Clf = clf.Clfs(nIndex);
                    % 进行预测
                    [YTest] = Clf.Predict(xTest);
                    % 转换内部分类结果
                    YTest(YTest==1) = i;
                    YTest(YTest==-1) = j;
                    % 记录真实分类结果
                    YTests(:, nIndex) = YTest;
                end
            end
            yTest = zeros(m, 1);
            yVote = zeros(1, clf.nClasses);
            for i = 1 : m
                % 统计分类得票
                for j = 1 : clf.nClasses
                    yVote(1, j) = sum(YTests(i, :) == j);
                end
                % 对分类得票进行排序
                [~, IDX] = sort(yVote(1, :), 'descend');
                % 选取得票数最多的一个作为分类结果
                yTest(i) = clf.Lables(IDX(1));
            end
        end
        function [ clf ] = SetParams(clf, params)
            % 设置分类器参数
            clf.Params = params;
            nIndex = 0;
            % 初始化所有分类器的参数
            for i = 1 : clf.nClasses - 1
                for j = i + 1 : clf.nClasses
                    nIndex = nIndex + 1;
                    Clf = clf.Clfs(nIndex);
                    Clf.SetParams(params);
                    clf.Clfs(nIndex) = Clf;
                end
            end
        end
        function [ params ] = GetParams(clf)
            % 得到分类器参数
            params = clf.Params;
        end
        function disp(clf)
            fprintf('%s: %d Classes\n', clf.Name, clf.nClasses);
        end
    end
    methods (Static)
        function [ Xr, Yr ] = OvO( X, Y, Lables, i, j )
            %OvO 此处显示有关此函数的摘要
            % i作为正类点，j负类点
            %   此处显示详细说明

            Ip = Y==Lables(i);
            In = Y==Lables(j);
            Xp = X(Ip, :);
            Yp = ones(length(Xp), 1);
            Xn = X(In, :);
            Yn = -ones(length(Xn), 1);
            Xr = [Xp; Xn];
            Yr = [Yp; Yn];
        end
        function [ Xr, Yr ] = OvR( X, Y, Lables, i)
            %OvO 此处显示有关此函数的摘要
            % i作为正类点，其余负类点
            %   此处显示详细说明
            Ip = Y==Lables(i);
            In = Y~=Lables(i);
            Xp = X(Ip, :);
            Yp = ones(length(Xp), 1);
            Xn = X(In, :);
            Yn = -ones(length(Xn), 1);
            Xr = [Xp; Xn];
            Yr = [Yp; Yn];
        end
    end
end