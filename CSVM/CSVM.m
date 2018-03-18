classdef CSVM
    %CSVM 此处显示有关此类的摘要
    % Kernel Support Vector Machine
    %   此处显示详细说明
    
    properties (Access = 'public')
        Name;   % 名称
        C;      % 参数
        Kernel; % 核函数
    end

    properties (Access = 'private')
        xTrain; % 训练样本
        yTrain; % 测试样本
        Alpha;  % 训练结果
    end
    
    methods (Access = 'public')
        function [ clf ] = CSVM(params)
        %CSVM 此处显示有关此函数的摘要
        % CSVM
        %   此处显示详细说明
            clf = clf.SetParams(params);
        end
        function [ clf, Time ] = Fit(clf, xTrain, yTrain)
            % 计时
            tic
            % 记录X, Y
            clf.xTrain = xTrain;
            clf.yTrain = yTrain;
            [m, ~] = size(xTrain);
            % 核矩阵
            K = clf.Kernel.K(xTrain, xTrain);
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
            K = clf.Kernel.K(xTest, clf.xTrain);
            % 预测值
            yTest = sign(K*diag(clf.yTrain)*clf.Alpha);
            % 将0换成1
            yTest(yTest==0) = 1;
        end
        function [ clf ] = SetParams(clf, params)
            % 设置分类器参数
            clf.Name = params.Name;
            clf.C = params.C;
            clf.Kernel = FKernel(params.Kernel);
        end
        function [ params ] = GetParams(clf)
            % 得到分类器参数
            kernel = clf.Kernel.GetParams();
            params = struct(clf);
            params = rmfield(params, 'Kernel');
            params = MergeStruct(params, kernel);
        end
        function disp(clf)
            fprintf('%s: C=%4.5f\n', clf.Name, clf.C);
        end
    end
    
end