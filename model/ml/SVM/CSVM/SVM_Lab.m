function [ Output ] = SVM_Lab(X1,Y1,tstX1,tstY1,X2,Y2,tstX2,tstY2,X3,Y3,tstX3,tstY3,X4,Y4,tstX4,tstY4,X5,Y5,tstX5,tstY5)
    
    c1 = 2.^[-1:0.2:3];
    p = 2.^[2:4:6];
    s = 0;
    Output = zeros(length(c1)*length(p), 5);
    
    % 网格搜索
    for i = 1:length(p)
        for j = 1:length(c1)
            s = s + 1;
            % 交叉验证
            kernel = struct('kernel', 'rbf', 'p1', p(i));
            opts = struct('C', c(j), 'kernel', kernel);
            [accuracy(1), t(1)] = KerSVM(X1,Y1,tstX1,tstY1,opts);
            [accuracy(2), t(2)] = KerSVM(X2,Y2,tstX2,tstY2,opts);
            [accuracy(3), t(3)] = KerSVM(X3,Y3,tstX3,tstY3,opts);
            [accuracy(4), t(4)] = KerSVM(X4,Y4,tstX4,tstY4,opts);
            [accuracy(5), t(5)] = KerSVM(X5,Y5,tstX5,tstY5,opts);
            Output(s, 1) = c1(j);
            Output(s, 2) = p(i);
            Output(s, 3) = mean(accuracy);
            Output(s, 4) = 100*std(accuracy,1);
            Output(s, 5) = mean(t);
        end
    end
    
    save('SVM_Lab.mat', 'Output');
end