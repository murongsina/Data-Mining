function [ ] = DrawResult(Stat, Time, labels, xLabels, arc)
%DRAWRESULT 此处显示有关此函数的摘要
% 绘制实验结果
%   此处显示详细说明
    if nargin < 5
        arc = 0;
    end
    subplot(1, 2, 1);
    bar(Stat);
    xlabel('#Task');
    ylabel('Accuracy (%)');
    legend(labels, 'Location', 'northwest');
    set(gca, 'XTicklabel', xLabels, 'XTickLabelRotation', arc);
    subplot(1, 2, 2);
    bar(Time);
    xlabel('#Task');
    ylabel('Training time (ms)');
    legend(labels, 'Location', 'northwest');
    set(gca, 'XTicklabel', xLabels, 'XTickLabelRotation', arc);
end

