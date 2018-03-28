classdef NaiveBayes
    %NAIVEBAYES 此处显示有关此类的摘要
    %   此处显示详细说明

    properties
        F;     % 特征类别：离散1/连续0
        Pc;    % 先验概率
        CP;    % 条件概率
        Cell;  % 离散特征转换表
    end

    methods
        function [ clf ] = NaiveBayes(F)
            clf.F = F;
        end
        function [ clf ] = Fit(clf, X, Y, F)
            % 预处理
            [ Dp, Cell ] = NaiveBayes.Prepare([X, Y], F);
            [ Dx, Dy ] = SplitDataLabel(Dp, 9);
            C = unique(Dy);
            % 训练
            C = sort(C);
            Cn = length(C);
            [m, n] = size(Dx);
            % 初始化离散特征转换表
            clf.Cell = Cell;
            % 初始化特征类别
            clf.F = F;
            % 初始化先验概率
            clf.Pc = histc(Dy, C)/m;
            % 为每个属性估计条件概率
            clf.CP = cell(Cn, n);
            % 对每一种分类
            for i = 1 : Cn
                % 得到该分类的子集
                Si = Dx(Dy==C(i), :);
                % 对每一个属性j
                for j = 1 : n
                    Sij = Si(:, j);
                    % 特征j是离散属性
                    if F(j) == 1
                        Fij = sort(unique(Sij));
                        Fn = length(Fij);
                        Fpc = zeros(Fn, 1);
                        % 对属性的每一个取值
                        for k = 1 : Fn
                            Sijk = Si(Si(:, j) == Fij(k));
                            % P(色泽=青绿|好瓜=是)
                            Fpc(k) = length(Sijk)/length(Si);
                        end
                        % 条件概率
                        clf.CP{i, j} = Fpc;
                    else
                        % 方均值和方差
                        clf.CP{i, j} = [mean(Sij), var(Sij)];
                    end
                end
            end
        end
        function [ clf, Yp ] = Predict(clf, X)
            % 预处理
            [ Xp ] = NaiveBayes.Transform(X, clf.F, clf.Cell);
            [~, n] = size(Xp);
            % 预测结果
            Yn = length(clf.Pc);
            Yp = ones(1, Yn);
            % 对每一种分类
            for i = 1 : Yn
                % 先验概率
                Yp(i) = clf.Pc(i);
                % 条件概率
                for j = 1 : n
                    % 得到i分类j特征的条件概率表
                    CPij = clf.CP{i, j};
                    % 如果是离散特征
                    if clf.F(j) == 1
                        % 计算概率
                        Yp(i) = Yp(i) * CPij(Xp(j));
                    else
                        % 得到均值、方差
                        Mean = CPij(1);
                        Var = CPij(2);
                        % 根据正态分布计算概率
                        Yp(i) = 1/(sqrt(2*pi*Var))*exp(-(Xp(j)-Mean)^2/(2*Var));
                    end
                end
            end
        end
    end
    methods(Static)
        function [ Dp, Cell ] = Prepare(D, F)
            [m, n] = size(D);
            Dp = zeros(m, n);
            % 离散特征转换表
            Cell = cell(n, 1);
            % 对每一个特征
            for i = 1 : n
                % 如果是连续特征
                if F(i) == 0
                    % 直接拷贝
                    Dp(:, i) = cell2mat(D(:, i));
                else
                    % 提取离散属性值
                    Di = D(:, i);
                    Ci = unique(Di);
                    Ci = sort(Ci);
                    Cn = length(Ci);
                    Cell{i} = Ci;
                    % 转换离散非数值属性
                    for j = 1 : Cn
                        Dp(strcmp(Di, Ci{j}), i) = j;
                    end
                end
            end
        end
        function [ Xp ] = Transform(X, F, Cell)
            % 得到样本维度
            [~, n] = size(X);
            Xp = zeros(1, n);
            % 对每一个特征
            for i = 1 : n
                % 如果是连续特征
                if F(i) == 0
                    % 直接拷贝
                    Xp(i) = X{i};
                else
                    % 转换离散非数值属性
                    Xp(i) = find(strcmp(Cell{i}, X{i}));
                end
            end
        end
    end
end