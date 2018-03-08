classdef KTWSVM
    %KTWSVM 此处显示有关此类的摘要
    % Kernel Twin Support Vector Machine
    %   此处显示详细说明
    
    properties (Access = 'public')
        Name;   % 分类器名称
        C1;     % 参数1
        C2;     % 参数2
        Kernel; % 核函数
        p1;     % 核参数1
        p2;     % 核参数2
        p3;     % 核参数3
    end
    
    properties (Access = 'private')
        C; % [A;B]
        u1; % KTWSVM1
        b1; % KTWSVM1
        u2; % KTWSVM2
        b2; % KTWSVM2
    end
    
    methods (Access = 'public')
        function [ clf ] = KTWSVM(C1, C2, Kernel, p1, p2, p3)
            clf.Name = 'KTWSVM';
            clf.Kernel = Kernel;
            clf.C1 = C1;
            clf.C2 = C2;
            if strcmp('linear', Kernel) == 0
                if nargin > 3
                    clf.p1 = p1;
                end
                if nargin > 4
                    clf.p2 = p2;
                end
                if nargin > 5
                    clf.p3 = p3;
                end
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
            S = [Utils.K(clf.Kernel, A, clf.C, clf.p1, clf.p2, clf.p3) e1];
            R = [Utils.K(clf.Kernel, B, clf.C, clf.p1, clf.p2, clf.p3) e2];
            S2 = S'*S;
            R2 = R'*R;
            % KDTWSVM1
            H1 = R/S2*R';
            H1 = Utils.Cond(H1);
            lb1 = zeros(m2, 1);
            ub1 = ones(m2, 1)*clf.C1;
            Alpha = quadprog(H1,-e2,[],[],[],[],lb1,ub1);
            z1 = -S2\R'*Alpha;
            clf.u1 = z1(1:n);
            clf.b1 = z1(end);
            % KDTWSVM2
            H2 = S/R2*S';
            H2 = Utils.Cond(H2);
            lb2 = zeros(m1, 1);
            ub2 = ones(m1, 1)*clf.C2;
            Mu = quadprog(H2,-e1,[],[],[],[],lb2,ub2);
            z2 = -R2\S'*Mu;
            clf.u2 = z2(1:n);
            clf.b2 = z2(end);
            % 停止计时
            Time = toc;
        end
        function [ yTest ] = Predict(clf, xTest)
            K = Utils.K(clf.Kernel, xTest, clf.C, clf.p1, clf.p2, clf.p3);
            D1 = abs(K*clf.u1+clf.b1);
            D2 = abs(K*clf.u2+clf.b2);
            yTest = sign(D2-D1);
            yTest(yTest==0) = 1;
        end
        function disp(clf)
            fprintf('KTWSVM-SVM: C1=%4.5f\tC2=%4.5f\n', clf.C1, clf.C2);
        end
    end
end