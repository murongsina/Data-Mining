images = '../images/CSVM/';

X = LR(:,1:2);
Y = LR(:,3);

h = figure('Visible', 'on');

% 绘制正负类散点图
title('MST_KNN');
xlabel('X1');
ylabel('X2');
SCATTER(LR);
hold on;

% 最近邻属性模式选择
idx = NPPS(X, Y, 15);

% 绘制散点图
Xn = X(Y(idx,1)==0,:);
scatter(Xn(:,1),Xn(:,2),32,'ob');
hold on;
Xp = X(Y(idx,1)==1,:);
scatter(Xp(:,1),Xp(:,2),32,'ob');
hold on;
