function [Output]=Svm_finally(X1,Y1,tstX1,tstY1,X2,Y2,tstX2,tstY2,X3,Y3,tstX3,tstY3,X4,Y4,tstX4,tstY4,X5,Y5,tstX5,tstY5)
    c1 = 2.^[-1:0.2:3];
    p = 2.^[2:4:6];
    s = 0;
    Output = zeros(length(c1)*length(p), 5);
    % 网格搜索
    for i = 1:length(p)
        for j = 1:length(c1)
            s = s + 1;
            % 交叉验证
            [accuracy(1), t(1)] = KerSVM(tstX1,tstY1,X1,Y1,c1(j),p(i));
            [accuracy(1), t(1)] = KerSVM(tstX2,tstY2,X2,Y2,c1(j),p(i));
            [accuracy(1), t(1)] = KerSVM(tstX3,tstY3,X3,Y3,c1(j),p(i));
            [accuracy(1), t(1)] = KerSVM(tstX4,tstY4,X4,Y4,c1(j),p(i));
            [accuracy(1), t(1)] = KerSVM(tstX5,tstY5,X5,Y5,c1(j),p(i));
            Output(s, 1) = c1(j); % 参数 C
            Output(s, 2) = p(i); % 参数 sigma
            Output(s, 3) = mean(accuracy); % 精度的平均值
            Output(s, 4) = 100*std(accuracy,1); % 精度的标准差
            Output(s, 5) = mean(t); % 平均时间
        end
    end
    save SVM_name Output
end