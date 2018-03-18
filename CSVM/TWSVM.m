classdef TWSVM
    %TWSVM 此处显示有关此类的摘要
    % Twin Support Vector Machine
    %   此处显示详细说明
    
    properties (Access = 'public')
        Name;   % 分类器名称
        C1;     % 参数1
        C2;     % 参数2
    end
    
    properties (Access = 'private')
        C;  % [A;B]
        w1; % TWSVM1
        b1; % TWSVM1
        w2; % TWSVM2
        b2; % TWSVM2
    end

    methods (Access = 'public')
        function [ clf ] = TWSVM(params)
            clf.Name = 'TWSVM';
            if nargin > 0
                clf.SetParams(params);
            end
            clf.w1 = [];
            clf.b1 = 0;
            clf.w2 = [];
            clf.b2 = 0;
        end
        function [ clf, Time ] = Fit(clf, xTrain, yTrain)
            % 计时
            tic
            % 分割正负类点
            A = xTrain(yTrain==1, :);
            B = xTrain(yTrain==-1, :);
            [m1, ~] = size(A);
            [m2, ~] = size(B);
            [~, n] = size(xTrain);
            e1 = ones(m1, 1);
            e2 = ones(m2, 1);
            % 构造J,Q矩阵
            J = [A e1];
            Q = [B e2];
            J2 = (J'*J);
            Q2 = (Q'*Q);
            % DTWSVM1
            lb1 = zeros(m2,1);
            ub1 = clf.C1*ones(m2,1);
            H1 = Q/J2*Q';
            H1 = Utils.Cond(H1);
            Alpha = quadprog(H1, -e2, [], [], [], [], lb1, ub1);
            u = -J2\Q'*Alpha;
            clf.w1 = u(1:n);
            clf.b1 = u(end);
            % DTWSVM2
            lb2 = zeros(m1, 1);
            ub2 = clf.C2*ones(m1, 1);
            H2 = J/Q2*J';
            H2 = Utils.Cond(H2);
            Beta = quadprog(H2, -e1, [], [], [], [], lb2, ub2);
            v = -Q2\J'*Beta; 
            clf.w2 = v(1:n, :);
            clf.b2 = v(end);
            % 停止计时
            Time = toc;
        end
        function [ yTest ] = Predict(clf, xTest)
            D1 = abs(xTest*clf.w1+clf.b1);
            D2 = abs(xTest*clf.w2+clf.b2);
            yTest = sign(D2-D1);
            yTest(yTest==0) = 1;
        end
        function [ clf ] = SetParams(clf, params)
            % 设置分类器参数
            clf.C1 = params.C1;
            clf.C2 = params.C2;
        end
        function [ params ] = GetParams(clf)
            % 得到分类器参数
            params = struct(clf);
        end
        function disp(clf)
            fprintf('%s: C1=%4.5f\tC2=%4.5f\n', clf.Name, clf.C1, clf.C2);
        end
    end
    
end