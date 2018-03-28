classdef SVM
    % C-支持向量机
    properties (Access = 'public')
        X;
        Y;
        class;
        ker = 'linear' % 核函数
        C; % 惩罚参数
        Sigma; % RBF核参数
        svi; % 支持向量
    end
    properties (Access = 'private')
        nsv;
        alpha;
        b0;
    end
    methods (Access = 'public')
        function clf = SVM(ker, C, Sigma)
            clf.ker = ker;
            clf.C = C;
            clf.Sigma = Sigma;
            clf.nsv = 0;
            clf.alpha = [];
            clf.b0 = 0;
        end
        function [ clf, Time ] = Fit(clf, xTrain, yTrain)
        % 训练
        % 参数：
        %    X    -训练集
        %    Y    -标签集
            clf.X = xTrain;
            clf.Y = yTrain;
            tic;
            % 开始训练
            [clf.nsv, clf.alpha, clf.b0 ] = SVM.svc( xTrain, yTrain, clf.ker, clf.C, clf.Sigma );
            % 输出支持向量个数
            fprintf('svi: %d\n', clf.nsv);
            % 根据alpha计算w
            epsilon = 10e-6;
            clf.svi = clf.alpha(:,1) > epsilon;
            % 结束训练
            Time = toc;
        end
        function [ yTest ] = Predict(clf, xTest)
        % 预测
        % 参数：
        %    x    -测试集
            
            svAlpha = clf.alpha(clf.svi,1);
            svX = clf.X(clf.svi,:);
            svY = clf.Y(clf.svi,:);
            % 输出x, y的信息
            [m, n] = size(xTest);
            fprintf('size x = [%d, %d]\n', m, n);
            % 在测试集上测试
            b = repmat(clf.b0, 1, m);
            % 输出预测结果
            yTest = sign(sum(svAlpha.*svY.*SVM.kernel(clf.ker, svX, xTest, clf.Sigma)) + b);
            yTest = yTest';
            yTest(yTest==0) = 1;
            % 将-1换成0，classperf要求
            yTest(yTest==-1) = 0;
            [m, n] = size(yTest);
            fprintf('size y = [%d, %d]\n', m, n);
        end
        function disp(clf)
            fprintf('Summary of clf:\n');
            fprintf('C:\t%d.\n', clf.C);
            fprintf('Sigma:\t%d.\n', clf.Sigma);
            fprintf('nsv:\t%d.\n', clf.nsv);
            fprintf('b0:\t%d.\n', clf.b0);
        end
    end
    methods (Static)
        function [ nsv, alpha, b0 ] = svc( X, Y, ker, C, Sigma )
        %SVC 此处显示有关此函数的摘要
        % SVC Support Vector Classification
        %
        %   Usage: [ nsv alpha bias] = svc(X, Y, ker, C)
        %
        %   Parameters: X        - Training inputs
        %               Y        - Training targets
        %               ker      - kernel function
        %               C        - upper bound (non-seperable case)
        %               nsv      - number of support vectors
        %               alpha    - Lagrange Multipliers
        %               b0       - bias term
        %
        %   此处显示详细说明

            if (nargin < 2 || nargin > 4) % check correct number of arguments
                help svc
            else
                n = size(X, 1);
                if (nargin < 4) 
                    C = inf;
                end
                if (nargin < 3)
                    ker = 'linear';
                end

                % Construct the H matrix and c vector

                H = zeros(n, n);
                for i = 1 : n
                    for j = 1 : n
                        H(i, j) = Y(i)*Y(j)*SVM.svkernel(ker, X(i,:), X(j,:), Sigma);
                    end
                end

                c = -ones(n, 1);

                % Add small amount of zero order regularisation to
                % avoid problems when Hessian is badly conditioned

                if (abs(cond(H)) > 1e+10)
                    fprintf('Hessian badly conditioned, regularising ....\n')
                    fprintf('    Old condition number: %4.2g\n', cond(H))
                    H = H + 0.00000001*eye(size(H));
                    fprintf('    New condition number: %4.2g\n', cond(H))
                end

                % Set up the parameters for the Optimisation problem
                A = []; % Ax <= b
                b = []; % Ax <= b
                vlb = zeros(n, 1);      % Set the bounds: alpha >= 0
                vub = C * ones(n, 1);   % Set the bounds: alpha <= C
                x0 = [ ];               % The starting point is [0 0 0 0]
                neqcstr = SVM.nobias(ker);  % Set the number of equality constraints (1 or 0)
                if neqcstr
                    Aeq = Y'; beq = 0;      % Set the constraint Ax = b
                else
                    Aeq = []; beq = [];
                end

                % Solve the Optimisation Problem

                st = cputime;

                if (vlb == zeros(size(vlb)) & (min(vub) == Inf) & (neqcstr == 0))
                    % Seperable problem with Implicit Bias term
                    % Use Non Negative Lease Squares
                    alpha = fnnls(H, -c);
                else
                    % Otherwise
                    % Use Quadratic Programming
                    % x = quadprog(H,f,A,b,Aeq,beq,lb,ub,x0,options)
                    alpha = quadprog(H, c, A, b, Aeq, beq, vlb, vub, x0);%, neqcstr, -1);
                end

                fprintf('Excution time: %4.1f seconds\n', cputime - st);
                fprintf('|w0|^2     : %f\n', alpha'*H*alpha);
                fprintf('Sum alpha  : %f\n', sum(alpha));

                % Compute the number of Support Vectors
                epsilon = 10e-6;
                svi = find(abs(alpha) > epsilon);
                nsv = length(svi);

                if (neqcstr == 0)
                    % Implicit bias, b0
                    b0 = 0;
                else
                    % Explicit bias, b0
                    % find b0 from pair of suppor vectors, one from each class
                    classAsvi = find(abs(alpha) > epsilon & Y == 1);
                    classBsvi = find(abs(alpha) > epsilon & Y == -1);
                    nAsv = length(classAsvi);
                    nBsv = length(classBsvi);
                    if (nAsv > 0 && nBsv > 0)
                        svpair = [classAsvi(1), classBsvi(1)];
                        b0 = -(1/2)*sum(Y(svpair)'*H(svpair, svi)*alpha(svi));
                    else
                        b0 = 0;
                    end
                end
            end
        end
        function [ k ] = svkernel(type, u, v, Sigma)
            %[m,n]=size(u);
            %fprintf('size u = [%d, %d]\n', m, n);
            %[m,n]=size(v);
            %fprintf('size v = [%d, %d]\n', m, n);
            switch type
                case 'linear'
                     % Linear Kernal
                     % disp('You are using a Linear Kernal')
                     k = u*v';
                case 'poly'
                     % Polynomial Kernal
                     % disp('You are using a Polynomial Kernal')
                     k = (u*v' + 1)^Sigma;
                case 'rbf'
                     %Radial Basia Function Kernal
                     %disp('You are using a RBF Kernal')
                     k = exp(-(u-v)*(u-v)'/(2 * Sigma.^2));   
                otherwise
                    disp('Please enter a Valid kernel choice ')
                    k=0;
            end            
        end
        function [ H ] = kernel( ker, U, V, Sigma )
        %KERNEL 此处显示有关此函数的摘要
        %   此处显示详细说明

            [ru, ~] = size(U);
            [rv, ~] = size(V);
            H = zeros(ru, rv);
            for i = 1 : ru
                for j = 1 : rv
                    H(i, j) = SVM.svkernel(ker, U(i,:), V(j,:), Sigma);
                end
            end
        end
        function [ nb ] = nobias( ker )
        % nobias 此处显示有关此函数的摘要
        % nobias returns true if SVM kernel has no implicit bias
        %
        %  Usage: nb = nobias(ker)
        %
        %  Parameters: ker - kernel type
        %              
        %   此处显示详细说明
            if (nargin ~= 1)
                help nobias
            else
                switch lower(ker)
                    case {'linear', 'rbf'}
                        nb = 1;
                    otherwise
                        nb = 0;
                end
            end
        end
    end
end