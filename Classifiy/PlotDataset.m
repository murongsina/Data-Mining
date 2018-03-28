function [  ] = PlotDataset( D, name, m, n, i, sz, cp, cn )
%PLOTDATASET 此处显示有关此函数的摘要
% 绘制数据集
%   此处显示详细说明
% 参数：
%     D    -数据集
%     m    -行
%     n    -列
%     i    -第i位
%    sz    -大小
%    cp    -正类点样式
%    cn    -负类点样式
%
    subplot(m, n, i);
    title(['Method: ', name]);
    xlabel('x1');
    ylabel('x2');
    Scatter(D, sz, cp, cn);
end