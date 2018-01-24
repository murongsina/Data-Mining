images = '../images/CSVM/';

% X = LR(:,1:2);
% Y = LR(:,3);
[X, Y] = Sine(1600);

h = figure('Visible', 'on');

% 绘制正负类散点图
title('MST_KNN');
xlabel('X1');
ylabel('X2');
SCATTER([X Y]);
hold on;

% 最近邻属性模式选择
% idx = NPPS(X, Y, 16);
% Xn = X(idx,:);

% 余弦和模式选择
Xn = NDP(X, Y, 24, 12, 12);

% 绘制散点图
scatter(Xn(:,1),Xn(:,2),24,'ob');
hold on

