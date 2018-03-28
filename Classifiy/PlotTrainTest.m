function [  ] = PlotTrainTest( h, images, DataSet, D1, DTrain, DTest, Colors )
%PLOTTRAINTEST 此处显示有关此函数的摘要
% 绘制训练测试集
%   此处显示详细说明

    clf(h);
    PlotMultiClass(DTrain, DataSet.Name, 1, 1, 1, 6, Colors);
    saveas(h, [images, DataSet.Name, '-Train.png']);
    savefig(h, [images, DataSet.Name, '-Train.fig']);
    clf(h);
    PlotMultiClass(DTest, DataSet.Name, 1, 1, 1, 6, Colors);
    saveas(h, [images, DataSet.Name, '-Test.png']);
    savefig(h, [images, DataSet.Name, '-Test.fig']);
    clf(h);
    PlotMultiClass(D1, DataSet.Name, 1, 1, 1, 6, Colors);
    saveas(h, [images, DataSet.Name, '-Predict.png']);
    savefig(h, [images, DataSet.Name, '-Predict.fig']);
end