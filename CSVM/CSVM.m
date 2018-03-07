classdef CSVM
    % C-支持向量机
    properties (Access = 'public')
        C; % 惩罚参数
        Sigma; % RBF核参数
    end
    properties (Access = 'private')
        X;
        Y;
        x;
    end
    methods (Access = 'public')
        function [ clf ] = CSVM(C, Sigma)
        %CSVM 此处显示有关此函数的摘要
        %   此处显示详细说明
            clf.C = C;
            clf.Sigma = Sigma;
        end
        function [ clf, Time ] = Fit(clf, xTrain, yTrain)
            % 记录X, Y
            clf.X = xTrain;
            clf.Y = yTrain;
            [L, ~] = size(xTrain);
            % 计时
            tic
            % 核矩阵
            K1 = exp(-(repmat(sum(xTrain.*xTrain, 2)', L, 1)+repmat(sum(xTrain.*xTrain, 2), 1, L)-2*(xTrain*xTrain'))/(2*clf.Sigma^2));
            H = diag(yTrain)*K1*diag(yTrain);
            % 常数项
            a = -ones(L, 1);
            % 上下界
            lb = zeros(L, 1);
            ub = clf.C*ones(L, 1);
            % 选项
            opts = []; 
            % 二次规划求解
            [ clf.x ] = quadprog(H, a, [], [], [], [], lb, ub, [], opts);
            % 停止计时
            Time = toc;
        end
        function [ yTest ] = Predict(clf, xTest)
            xTrain = clf.X;
            yTrain = clf.Y;
            [L, ~] = size(xTrain);
            [s, ~] = size(xTest);
            % 核矩阵
            KT = exp(-(repmat(sum(xTest.*xTest, 2)', L, 1)+repmat(sum(xTrain.*xTrain, 2), 1, s) - 2*xTrain*xTest')/(2*clf.Sigma^2));
            KT = KT';
            % f(x) = kernel(X, x) * Y * x
            PY = KT*diag(yTrain)*clf.x;
            % 预测值
            yTest = sign(PY);
            % 将0换成1
            yTest(yTest==0) = 1;
        end
        function disp(clf)
            fprintf('C-SVM: C=%4.5f\tSigma=%4.5f\n', clf.C, clf.Sigma);
        end
    end
end