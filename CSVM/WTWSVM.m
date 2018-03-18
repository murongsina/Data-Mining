classdef WTWSVM
    %WTWSVM 此处显示有关此类的摘要
    % Weighted Twin Support Vector Machine
    %   此处显示详细说明
    
    properties
        Name;   % 分类器名称
        C1;     % 参数1
        C2;     % 参数2
        W;      % 权重矩阵
        Kernel; % 核函数
    end    
    
    properties (Access = 'private')
        C;  % [A;B]
        w1; % WTWSVM1
        b1; % WTWSVM1
        w2; % WTWSVM2
        b2; % WTWSVM2
    end
    
    methods (Access = 'public')
        function [ clf ] = WTWSVM(params)
            clf.Name = 'WTWSVM';
            clf = clf.SetParams(params);
        end
        function [ clf, Time ] = Fit(clf, xTrain, yTrain)
            % 计时
            tic
            % 分割正负类点
            A = xTrain(yTrain==1, :);
            B = xTrain(yTrain==-1, :);
            [m1, ~] = size(A);
            [m2, ~] = size(B);
            n = m1 + m2;
            e1 = ones(m1, 1);
            e2 = ones(m2, 1);
            % 转换权重矩阵
            % 构造核矩阵
            clf.C = [A; B];
            E = [Utils.K(clf.Kernel, A, clf.C, clf.p1, clf.p2, clf.p3) e1];
            F = [Utils.K(clf.Kernel, B, clf.C, clf.p1, clf.p2, clf.p3) e2];
            E2 = E'*E;
            F2 = F'*F;
            % LS-TWSVM1
            u1 = -(F2+1/clf.C1*E2)\F'*e2;
            clf.w1 = u1(1:n);
            clf.b1 = u1(end);
            % LS-TWSVM2
            u2 = +(E2+1/clf.C2*F2)\E'*e1;
            clf.w2 = u2(1:n);
            clf.b2 = u2(end);
            % 停止计时
            Time = toc;
        end
        function [ yTest ] = Predict(clf, xTest)
            KX = Utils.K(clf.Kernel, xTest, clf.C, clf.p1, clf.p2, clf.p3);
            D1 = abs(KX*clf.w1+clf.b1);
            D2 = abs(KX*clf.w2+clf.b2);
            yTest = sign(D2-D1);
            yTest(yTest==0) = 1;
        end
        function [ clf ] = SetParams(clf, params)
            clf.C1 = params.C1;
            clf.C2 = params.C2;
            clf.W = params.W;
            clf.Kernel = params.Kernel;
        end
        function disp(clf)
            fprintf('%s: C1=%4.5f\tC2=%4.5f\n', clf.Name, clf.C1, clf.C2);
        end
    end
    
end

