images = '../images/ComparativeDensityPeaks/';
logPath = './log.txt';

% 数据集
DataSets = Artificial;
% 绘图
h = figure();
% 数据集
for i = [1 2 4]
    DataSet = DataSets(i);
    Data = DataLabel(DataSet.Data, DataSet.LabelColumn);
    Name = DataSet.Name;
    nCluster = DataSet.Classes;
    [ X, Y ] = SplitDataLabel(Data);
    % 密度峰值聚类
%     [ C, ~, Rho, Delta, Gamma, idx, DeltaTree, Halo, nCore, nHalo ] = DP( X, nCluster );
%     [ C, ~, Rho, Delta, Tau, Gamma, idx, DeltaTree ] = CDP( X, Y, nCluster, false );
    [ C, V, Gamma, k ] = KNNSTWSVM.Clustering(X, pi/6);
    fprintf('%s Has %d clusters.\n', Name, k);
    % 绘制ρ-δ散点图
%     clf(h);
%     S = [ Rho, Delta, Y ];
%     V = S(idx, :);
%     PlotMultiClass(S, Name, 1, 1, 1, 6, Colors);
%     PlotMultiClass(V, Name, 1, 1, 1, 32, Colors);
%     saveas(h, [images, 'runCDP-', Name, '-RhoDelta', '.png']);
    % 绘制DeltaTree
%     clf(h);
%     PlotTree(X, DeltaTree, Rho);
%     PlotMultiClass(Data, Name, 1, 1, 1, 6, Colors);
%     PlotMultiClass(Data(idx, :), Name, 1, 1, 1, 32, Colors);
%     saveas(h, [images, 'runCDP-', Name, '-DeltaTree', '.png']);
    % 绘制γ曲线
    clf(h);
    [ gamma_sorted, gamma_idx ] = sort(Gamma, 'descend');
    Gx = (1:DataSet.Instances-2).';
    G = [ Gx, gamma_sorted, Y(gamma_idx) ];
    Gr = G(1:15, :);
    scatter(Gr(:,1), Gr(:,2), 12, '.b');
    hold on
    scatter(Gr(1:nCluster,1), Gr(1:nCluster,2), 96, '.b');
    saveas(h, [images, 'runCDP-', Name, '-Gamma', '.png']);
    % 绘制原始样本
%     clf(h);
%     PlotMultiClass(Data, Name, 1, 1, 1, 3, Colors);
%     saveas(h, [images, 'runCDP-', Name, '-Initial', '.png']);
    % 绘制聚类结果
    clf(h);
    PlotMultiClass([X, C], Name, 1, 1, 1, 6, Colors);
    saveas(h, [images, 'runCDP-', Name, '-Result', '.png']);
    % 绘制Halo
    % clf(h);
%     PlotMultiClass(DC(Halo==0, :), Name, 1, 1, 1, 3, Colors);
%     saveas(h, [images, 'runCDP-', Name, '-Halo', '.png']);
%     样本选择
    [Xr, Yr, W] = LDP(X, Y, nCluster, 0.5);
%     绘制样本选择结果
    clf(h);
    PlotMultiClass([Xr, Yr], Name, 1, 1, 1, 6, Colors);
    saveas(h, [images, 'runCDP-', Name, '-Selection', '.png']);
end