function [accuracy,t]=KerSVM(tstX,tstY,X,Y,C,p1)
    opts=[];
    [L,~]=size(X);

    % 核矩阵
    K1 = exp(-(repmat(sum(X.*X,2)',L,1)+repmat(sum(X.*X,2),1,L)-2*(X*X'))/(2*p1^2));
    H = diag(Y)*K1*diag(Y);
    % 计时
    tic
    % 常数项
    a = -ones(L,1);
    % 上下界
    lb = zeros(L,1);
    ub = C*ones(L,1);
    % 二次规划求解
    [x] = quadprog(H,a,[],[],[],[],lb,ub,[],opts);
    % 停止计时
    t = toc;

    [s,~] = size(tstX);
    % 核矩阵
    KT = exp(-(repmat(sum(tstX.*tstX,2)',L,1)+repmat(sum(X.*X,2),1,s) - 2*X*tstX')/(2*p1^2)); KT = KT';
    % f(x) = kernel(x, x) * Y * X
    PY = KT*diag(Y)*x;
    % 预测值
    pre = sign(PY);
    % 预测值为0的改为1
    pre(pre==0)=1;
    % 计算精确度
    accuracy=mean(pre==tstY);
end


