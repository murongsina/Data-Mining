function [ yTest, Time ] = FSVM(xTrain, yTrain, xTest, opts)
%Field SVM 此处显示有关此类的摘要
% Kernel Support Vector Machine
%   此处显示详细说明
    
    % 设置分类器参数
    C = opts.C;
    T = opts.T;
    TaskNum = opts.TaskNum;
    kernel = opts.kernel;
    
    [ X, Y, T ] = GetAllData(xTrain, yTrain, TaskNum);
    [m, ~] = size(X);
    e = ones(m, 1);
    Anew = SNTFit(X, Y, T, TaskNum);
    [ xTest ] = SNT(xTest, A, T, TaskNum)
    [ yTest ] = Predict(Alpha);
    % 停止计时
    Time = toc;
    
    function [ Anew ] = SNTFit(xTrain, yTrain, zTrain, T)
        [~, n] = size(xTrain);
        % 定义A矩阵
        Aold = ones(n, n, T);
        Anew = ones(n, n, T);
        for i = 1 : T
            Anew(:,:,i) = diag(ones(1, n));
            Aold = Anew;
        end
        % 交替求解CSVM-Style Normalization Transformation (SNT)
        while (true)
            % 1. SNT 样式规范化转换
            [ xTrain ] = SNT(xTrain, A, T, TaskNum);
            % 2. CSVM Learning 在转换后的样本上训练
            [ W, Alpha ] = Fit(xTrain, yTrain, C);
            % 3. SNT 学习. 根据公式(5)更新变换矩阵A
            for i = 1 : T
                Tt = T==i; % 根据公式(5)更新变换矩阵Ai
                Wi = GetW(xTrain(Tt,:), yTrain(Tt,:), Alpha(Tt,:));
                Anew(:,:,i) = W*Wi'/(2*T);
            end
            % 4. Check Convergence.  如果学到的SNT变化不大，就退出
            if norm(Anew-Aold, 'fro') > 0.0001
                Aold = Anew;
            else
                break;
            end
        end
    end

    function [ xTrain ] = SNT(xTrain, A, T, TaskNum)
       % SNT
        for i = 1 : TaskNum
            xTrain(T==i,:) = A(:,:,i)*xTrain(T==i,:);
        end
    end

    function [ W, Alpha ] = Fit(xTrain, yTrain, C)
        K = Kernel(xTrain, xTrain, kernel);
        H = Cond(diag(yTrain)*K*diag(yTrain));
        Alpha = quadprog(H, -e, [], [], [], [], zeros(m, 1), C*e, [], []);
        svi = Alpha > 0;
        W = K(svi:svi)*diag(yTrain(svi))*Alpha(svi);
    end

    function [ yTest ] = Predict(Alpha)
        K = Kernel(xTest, xTrain, kernel);
        yTest = sign(K*diag(yTrain)*Alpha);
        yTest(yTest==0) = 1;
    end

end