function [  ] = PlotCurve( X, Y, name, m, n, i, sz, color )
%PLOTCURVE 此处显示有关此函数的摘要
% 绘制曲线
%   此处显示详细说明
% 参数：
%     D    -数据集
%  name    -图表名称
%     m    -行
%     n    -列
%     i    -第i位
%    sz    -大小
% color    -颜色

    % 对x坐标排序
    [x, idx] = sort(X(:,1));
    y = Y(idx,1);
    % 绘图
    subplot(m, n, i);
    title(name);
    xlabel('x');
    ylabel('y');
    plot(x, y, sz, color);
    hold on
end