classdef KSVM
    %KSVM 此处显示有关此类的摘要
    % Kernel Support Vector Machine
    %   此处显示详细说明
    
    properties (Access = 'public')
        Name;   % 名称
        C;      % 参数
        Kernel; % 核函数
        p1;     % 核参数1
        p2;     % 核参数2
        p3;     % 核参数3
    end
    
    properties (Access = 'private')
        xTrain; % 训练样本
        yTrain; % 测试样本
        Alpha;  % 训练结果
    end
    
    methods (Access = 'public')
        function [ clf ] = KSVM(C, Kernel, p1, p2, p3)
        %KSVM 此处显示有关此函数的摘要
        % KSVM
        %   此处显示详细说明
            clf.Name = 'KSVM';
            clf.C = C;
            clf.Kernel = Kernel;
            if strcmp('linear', Kernel) == 0
                if nargin > 2
                    clf.p1 = p1;
                end
                if nargin > 3
                    clf.p2 = p2;
                end
                if nargin > 4
                    clf.p3 = p3;
                end
            end
        end
        function [ clf, Time ] = Fit(clf, xTrain, yTrain)
            % 计时
            tic
            % 记录X, Y
            clf.xTrain = xTrain;
            clf.yTrain = yTrain;
            [m, ~] = size(xTrain);
            % 核矩阵
            K = Utils.K(clf.Kernel, xTrain, xTrain, clf.p1, clf.p2, clf.p3);
            % 常数项
            a = -ones(m, 1);
            lb = zeros(m, 1);
            ub = clf.C*ones(m, 1);
            H = diag(yTrain)*K*diag(yTrain);
            H = Utils.Cond(H);
            % 二次规划求解
            [ clf.Alpha ] = quadprog(H, a, [], [], [], [], lb, ub, [], []);
            % 停止计时
            Time = toc;
        end
        function [ yTest ] = Predict(clf, xTest)
            % 核矩阵
            K = Utils.K(clf.Kernel, xTest, clf.xTrain, clf.p1, clf.p2, clf.p3);
            % 预测值
            yTest = sign(K*diag(clf.yTrain)*clf.Alpha);
            % 将0换成1
            yTest(yTest==0) = 1;
        end
        function disp(clf)
            fprintf('%s: C=%4.5f\n', clf.Name, clf.C);
        end
    end
end