function [  ] = LogRegression( X, Y, Optimizer, NumIter )
%LOGREGRESSION 此处显示有关此函数的摘要
%   此处显示详细说明
    if ismatrix(X) == 1
        [m, ~] = size(X);
    end
    % 左边添加一列
    e = ones(m, 1);
    X = [e X];
    % 输出矩阵大小
    [m, n] = size(X);
    fprintf('size = [%d, %d]\n', m, n);
    % Logistic梯度优化
    if Optimizer == 'SGA'
        W = SGA(X, Y, NumIter);
    else
        W = BGA(X, Y, NumIter);
    end
    % 绘图
    fg = figure(1);
    title('LR-BGA');
    xlabel('x1');
    ylabel('x2');
    % 绘制所有点
    %scatter(X(:,2), X(:,3), 1, '*');
    %hold on;
    % 绘制正类点
    XP = X(Y(:,1)==1,:);
    scatter(XP(:,2), XP(:,3), 12, '+');
    hold on;
    % 绘制负类点
    XN = X(Y(:,1)==0,:);
    scatter(XN(:,2), XN(:,3), 12, 'O');
    hold on;
    % 绘制拟合曲线
    x = -3.0:0.1:3.0;
    y = (-W(1)-W(2)*x)/W(3);
    plot(x, y);
    % 保存图片
    saveas(fg, ['../images/', 'LR-BGA.png']);
end

