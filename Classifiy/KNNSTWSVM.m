classdef KNNSTWSVM
    %KNNSTWSVM 此处显示有关此类的摘要
    % KNN based Structural Twin Support Vector Machine
    %   此处显示详细说明
    
    properties (Access = 'public')
        Name;   % 分类器名称
        c1;     % 参数1
        c2;     % 参数2
        c3;     % 参数3
        c4;     % 参数4
        Kernel; % 核函数
    end
    
    properties (Access = 'private')
        C;  % [A;B]
        u1; % KTWSVM1
        b1; % KTWSVM1
        u2; % KTWSVM2
        b2; % KTWSVM2
    end
    
    methods (Access = 'public')
        function [ clf ] = KNNSTWSVM(params)
            clf.Name = 'KNNSTWSVM';
            if nargin == 1
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
            KA = clf.Kernel.K(A, clf.C);
            KB = clf.Kernel.K(B, clf.C);
            H = [KA e1];
            G = [KB e2];
            % 构造F1，F2样本选择矩阵
            F1 = KNNSTWSVM.Flag(A, B);
            F2 = KNNSTWSVM.Flag(B, A);
            % 样本加权
%             W = KNNSTWSVM.Weight(xTrain, yTrain, 2);
%             W1 = W(yTrain==1, :);
%             W2 = W(yTrain==-1, :);
            % 构造同类k近邻图W
            [~, ~, W1] = Utils.KnnGraph(A, 8);
            [~, ~, W2] = Utils.KnnGraph(B, 8);
            % 进行密度峰值聚类
            [C1, ~, ~, k1] = KNNSTWSVM.Clustering(KA, pi/6);
            [C2, ~, ~, k2] = KNNSTWSVM.Clustering(KB, pi/6);
            % 构造类内协方差矩阵
            J1 = KNNSTWSVM.Cov(KA, C1, k1);
            J2 = KNNSTWSVM.Cov(KB, C2, k2);
            % KNN-S-TWSVM1
            D = diag(sum(W1, 1)); % 对W1每一列求和
            F = diag(F2); % 只是使用相互最近邻做样本选择
            FG = F'*G;
            HDH = H'*D*H + clf.c2*J1;
            H1 = FG/HDH*FG';
            H1 = Utils.Cond(H1);
            lb1 = zeros(m2, 1);
            ub1 = ones(m2, 1)*clf.c1;
            Alpha = quadprog(H1,-e2'*F,[],[],[],[],lb1,ub1);
            z1 = -Utils.Cond(HDH)\FG'*Alpha;
            clf.u1 = z1(1:n);
            clf.b1 = z1(end);
            % KNN-S-TWSVM2
            Q = diag(sum(W2, 1)); % 对W2每一列求和
            P = diag(F1); % 只是使用相互最近邻做样本选择
            PH = P'*H;
            GQG = G'*Q*G + clf.c4*J2;
            H2 = PH/GQG*PH';
            H2 = Utils.Cond(H2);
            lb2 = zeros(m1, 1);
            ub2 = ones(m1, 1)*clf.c3;
            Gamma = quadprog(H2,-e1'*P,[],[],[],[],lb2,ub2);
            z2 = Utils.Cond(GQG)\PH'*Gamma;
            clf.u2 = z2(1:n);
            clf.b2 = z2(end);
            % 停止计时
            Time = toc;
        end
        function [ yTest ] = Predict(clf, xTest)
            K = clf.Kernel.K(xTest, clf.C);
            D1 = abs(K*clf.u1+clf.b1);
            D2 = abs(K*clf.u2+clf.b2);
            yTest = sign(D2-D1);
            yTest(yTest==0) = 1;
        end
        function [ clf ] = SetParams(clf, params)
            % 设置分类器参数
            clf.c1 = params.c1;
            clf.c2 = params.c2;
            clf.c3 = params.c3;
            clf.c4 = params.c4;
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
            fprintf('%s:\n', clf.Name);
            fprintf('C:\t%d\t%d\t%d\t%d\n', clf.c1, clf.c2, clf.c3, clf.c4);
            fprintf('Kennel:%s\n', clf.Kernel);
        end
    end
    methods (Static)
        function [ W ] = Weight(X, Y, k)
            % NPPS
%             [~, ~, W] = NPPS(X, Y, 12);
            % LDP
            [~, ~, W] = LDP(X, Y, k, 0.2);
        end
        function [ F ] = Flag(A, B)
            [m1, ~] = size(A);
            F = zeros(m1, 1);
            f = knnsearch(A, B, 'K', 8);
            f = unique(f);
            F(f) = 1;
        end
        function [ J ] = Cov(X, C, k)
            [~, n] = size(X);
            J = zeros(n + 1, n + 1);
            for i = 1 : k
                J(1:n,1:n) = J(1:n,1:n) + cov(X(C==i, :));
            end
        end
        function [ C, V, GammaKnee, k ] = Clustering(X, diff)
            % 初始化簇划分
            [m, ~] = size(X);
            C = zeros(m, 1);
            % 计算距离矩阵
            d = DIST(X);
            % 选取前2%距离为dc
            du = triu(d); % 取上三角
            sdu = sort(du(:)); % 升序排列
            sdu = sdu(sdu > 0); % 大于0的距离
            l = m*(m-1)/2;
            rate = 0.02;
            dc = sdu(round(l*rate));
            Rho = zeros(m, 1);
            for i = 1 : m
                j = setdiff(1 : m, i);
                di = d(i, j);
                % 1. Cut-off.
                Rho(i) = sum(di<dc);
                % 2. Guassian kernel.
                Rho(i) = sum(exp(-(di.*di)/(dc*dc)));
            end
            [~, rho_idx] = sort(Rho, 'descend');
            % delta[i] is measured by computing the minimum distance between the
            % point i and any other point with higher density
            Delta = zeros(m, 1);
            DeltaTree = zeros(m, 1);
            % Build Delta-Tree
            Peak = rho_idx(1);
            Delta(Peak) = max(d(Peak, :));
            DeltaTree(Peak) = Peak;
            for i = 2 : m
                % cluster center
                Peak = rho_idx(i);
                % find the nearest neighbour from the points with higher density 
                higher = rho_idx(1:i-1);
                [dist, idx] = min(d(Peak, higher));
                Delta(Peak) = dist;
                DeltaTree(Peak) = higher(idx);
            end
            % A hint for choosing the number of centers is provided by 
            % the plot of gamma = rho*delta sorted in decreasing order
            GammaDiff = Rho.*Delta;
            [ ~, gamma_idx ] = sort(GammaDiff, 'descend');
            % select k according to steady point.
            GammaDiff = GammaDiff(gamma_idx(1:m-1)) - GammaDiff(gamma_idx(2:m));
            GammaKnee = GammaDiff(1:m-2)./GammaDiff(2:m-1);
            GammaKnee = atan(GammaKnee);
            ids = find(GammaKnee < diff);
            k = ids(1);
            idx = gamma_idx(1:k);
            % Hence, as anticipated, the only points of high delta and relatively high ρ
            % are the cluster centers.
            DeltaTree(idx) = idx;
            V = X(idx);
            % assignation
            C(idx) = (1:k).';
            for i = 1 : m
                u = rho_idx(i);
                % assign cluster label
                if C(u) == 0
                    C(u) = C(DeltaTree(u));
                end
            end
        end
    end
end