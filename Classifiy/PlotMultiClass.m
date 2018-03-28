function [  ] = PlotMultiClass( D, name, m, n, i, sz, colors )
%PLOTMULTICLASS 此处显示有关此函数的摘要
% 绘制多分类数据集
%   此处显示详细说明
% 参数：
%     D    -数据集
%  name    -图表名称
%     m    -行
%     n    -列
%     i    -第i位
%    sz    -大小

    % 分割样本和标签
    [X, Y] = SplitDataLabel(D);
    % 得到有序的类别集
    C = unique(Y);
    C = sort(C);
    Cn = length(C);
    % 分别绘制每一类点
    for j = 1 : Cn
        subplot(m, n, i);
        title(['Dataset: ', name]);
        xlabel('x1');
        ylabel('x2');
        % 选出第j类样本绘制散点图
        Xj = X(Y==C(j), :);
        scatter(Xj(:, 1), Xj(:, 2), sz, colors(j, :));
        hold on
    end
end