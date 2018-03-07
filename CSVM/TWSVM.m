classdef TWSVM
    %TWSVM 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties (Access = 'public')
        W; % 超平面w数组
        B; % 超平面b数组
        C1; % 参数1
        C2; % 参数2
    end

    methods (Access = 'public')
        function [ clf ] = TWSVM(C1, C2)
            clf.W = [];
            clf.B = [];
            clf.C1 = C1;
            clf.C2 = C2;
        end
        function [ clf, Time ] = Fit(clf, xTrain, yTrain)
            tic
            [~, n1] = size(xTrain);

            Xp = xTrain(yTrain==1, :);
            Xn = xTrain(yTrain==-1, :);

            a = length(Xp);
            b = length(Xn);
            e1 = ones(a,1);
            e2 = ones(b,1);
            R = [Xp e1];
            S = [Xn e2];
            f1 = -ones(a,1);
            f2 = -ones(b,1);

            lb1 = zeros(b,1);
            ub1 = clf.C1*ones(b,1);
            IH1 = pinv(R'*R);
            H1 = S*IH1*S';
            [alpha, ~] = quadprog(H1, f2, [], [], [], [], lb1, ub1);
            Alpha = alpha;

            lb2 = zeros(a, 1);
            ub2 = clf.C2*ones(a, 1);
            IH2 = pinv(S'*S);
            H2 = R*IH2*R';
            [beta, ~] = quadprog(H2,f1,[],[],[],[],lb2,ub2);
            Beta = beta;

            u = -IH1*S'*Alpha;
            w1 = u(1:n1, :);
            b1 = u(end);

            v = -IH2*R'*Beta; 
            w2 = v(1:n1, :);
            b2 = v(end);

            clf.W = [w1 w2];
            clf.B = [b1 b2];
            
            Time = toc;
        end        
        function [ yTest ] = Predict(clf, xTest)
            C = abs(xTest*clf.W + clf.B);
            yTest = sign(C(:,2)-C(:,1));
            yTest(yTest==0) = 1;
        end
        function disp(clf)
            fprintf('TWIN-SVM: C1=%4.5f\tC2=%4.5f\n', clf.C1, clf.C2);
        end
    end
end