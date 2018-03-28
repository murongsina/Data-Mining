classdef LSTWSVM
    %LSTWSVM 此处显示有关此类的摘要
    % Least Square Twin Support Vector Machine
    %   此处显示详细说明
    
    properties (Access = 'public')
        Name;   % 分类器名称
        C1;     % 参数1
        C2;     % 参数2
        Kernel; % 核函数
    end
    
    properties (Access = 'private')
        C;  % [A;B]
        w1; % LSTWSVM1
        b1; % LSTWSVM1
        w2; % LSTWSVM2
        b2; % LSTWSVM2
    end
    
    methods (Access = 'public')
        function [ clf ] = LSTWSVM(params)
            clf.Name = 'LSTWSVM';
            if nargin > 0
                clf = clf.SetParams(params);
            end
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
            % 构造核矩阵
            clf.C = [A; B];
            E = [clf.Kernel.K(A, clf.C) e1];
            F = [clf.Kernel.K(B, clf.C) e2];
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
            K = Utils.K(clf.Kernel, xTest, clf.C, clf.p1, clf.p2, clf.p3);
            D1 = abs(K*clf.w1+clf.b1);
            D2 = abs(K*clf.w2+clf.b2);
            yTest = sign(D2-D1);
            yTest(yTest==0) = 1;
        end
        function [ clf ] = SetParams(clf, params)
            % 设置分类器参数
            clf.C1 = params.C1;
            clf.C2 = params.C2;
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
            fprintf('%s: C1=%4.5f\tC2=%4.5f\n', clf.Name, clf.C1, clf.C2);
        end
    end
    
end