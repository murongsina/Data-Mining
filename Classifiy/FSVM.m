classdef FSVM
    %Field SVM 此处显示有关此类的摘要
    % Kernel Support Vector Machine
    %   此处显示详细说明
    
    properties (Access = 'public')
        Name;   % 名称
        C;      % 参数
        T;      % T迁移惩罚参数
        Kernel; % 核函数
    end

    properties (Access = 'private')
        xTrain; % 训练样本
        yTrain; % 测试样本
        Alpha;  % 训练结果
        SV;     % 支持向量
        W;      % W;
    end
    
    methods (Access = 'public')
        function [ clf ] = FSVM(params)
        %CSVM 此处显示有关此函数的摘要
        % CSVM
        %   此处显示详细说明
            clf.Name = 'FSVM';
            clf = clf.SetParams(params);
        end
        function [ clf ] = SNTFit(clf, xTrain, yTrain, zTrain, zN)
            [~, n] = size(xTrain);
            % 定义A矩阵
            Aold = ones(n, n, zN);
            Anew = ones(n, n, zN);
            for i = 1 : zN
                Anew(:,:,i) = diag(ones(1, n));
                Aold = Anew;
            end
            % 交替求解CSVM-Style Normalization Transformation (SNT)
            while (true)
                % 1. SNT 样式规范化转换
                XTrain = FSVM.SNT(A, xTrain, zTrain, zN);
                % 2. CSVM Learning 在转换后的样本上训练
                [ ~ ] = clf.Fit(XTrain, yTrain);
                % 3. SNT 学习. 根据公式(5)更新变换矩阵A
                clf.W = clf.GetW(XTrain, yTrain, clf.Alpha);
                for i = 1 : zN
                    zi = find(zTrain==i); % 根据公式(5)更新变换矩阵Ai
                    Wi = clf.GetW(XTrain(zi,:), yTrain(zi,:), clf.Alpha(zi,:));
                    Anew(:,:,i) = clf.W*Wi'/(2*clf.T);
                end
                % 4. Check Convergence.  如果学到的SNT变化不大，就退出
                if norm(Anew-Aold, 'fro') > 0.0001
                    Aold = Anew;
                else
                    break;
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
            K = clf.Kernel.K(xTrain, xTrain);
            % 常数项
            a = -ones(m, 1);
            lb = zeros(m, 1);
            ub = clf.C*ones(m, 1);
            H = diag(yTrain)*K*diag(yTrain);
            H = Utils.Cond(H);
            % 二次规划求解
            [ clf.Alpha ] = quadprog(H, a, [], [], [], [], lb, ub, [], []);
            clf.SV = clf.Alpha > 0;
            % 停止计时
            Time = toc;
        end
        function [ W ] = GetW(clf, xTrain, yTrain, Alpha)
            svi = find(Alpha > 0);
            XTrain = xTrain(svi);
            YTrain = yTrain(svi);
            KXTrain = clf.Kernel.K(XTrain, xTrain);
            W = KXTrain*diag(YTrain)*Alpha;
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
            clf.C = params.C;
            clf.T = params.T;
            clf.Kernel = FKernel(params.Kernel);
        end
        function [ params ] = GetParams(clf)
            % 得到分类器参数
            params = struct(clf);
            kernel = params.Kernel.GetParams();
            params = rmfield(params, 'Kernel');
            params = MergeStruct(params, kernel);
        end
        function disp(clf)
            fprintf('%s: C=%4.5f\n', clf.Name, clf.C);
        end
    end
    
    methods (Static)        
        function [ xTrain ] = SNT(A, xTrain, zTrain, zN)
            % Iteration.
            % SNT
            for i = 1 : zN
                xTrain(zTrain==i,:) = A(:,:,i)*xTrain(zTrain==i,:);
            end
        end
    end
    
end