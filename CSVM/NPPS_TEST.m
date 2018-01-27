images = '../images/CSVM/';

% X = LR(:,1:2);
% Y = LR(:,3);
[X, Y] = Sine(6000);
% [X, Y] = Grid(6000, 2, 2, 1);
% [X, Y] = Nine();
% [X, Y] = Ring(4000, 2, 2);

% 绘制正负类散点图
h = figure('Visible', 'on');
% subplot(2,2,1);
% title('Subplot 1: Grid')
% xlabel('X1');
% ylabel('X2');
SCATTER([X Y]);
hold on;

% 最近邻属性模式选择
% [Xn, Yn] = NPPS(X, Y, 16);
% subplot(2,2,2);
% title('Subplot 2: NPPS')
% xlabel('X1');
% ylabel('X2');
% SCATTER([Xn Yn]);
% hold on

% 余弦和模式选择
% [Xn, Yn] = NDP(X, Y, 24, 12, 12);
% subplot(2,2,3);
% title('Subplot 3: NDP')
% xlabel('X1');
% ylabel('X2');
% SCATTER([Xn Yn]);
% hold on

% 固定近邻球样本选择
% [Xn, Yn] = FNSSS(X, Y, 1, 1500);
% subplot(2,2,4);
% title('Subplot 4: FNSSS')
% xlabel('X1');
% ylabel('X2');
% SCATTER([Xn Yn]);
% hold on

% 不稳定分割点样本选择
% [Xn, Yn] = NSCP(X, Y, 1);

% 基于距离的样本选择方法
[Xn, Yn] = DSSM(X, Y, 1000);

% 基于k近邻的样本选择
% [Xn, Yn] = KSSM(X, Y, 5);

% 绘制散点图
% h = figure('Visible', 'on');
scatter(Xn(:,1), Xn(:,2), 24, 'ob');
hold on
saveas(h, [images, 'DSSM_Sine.png']);