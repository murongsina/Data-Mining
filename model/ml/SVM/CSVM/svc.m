function [ nsv, alpha, b0 ] = svc( X, Y, ker, C )
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
                H(i, j) = Y(i)*Y(j)*svkernel(ker, X(i,:), X(j,:));
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
        neqcstr = nobias(ker);  % Set the number of equality constraints (1 or 0)
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

