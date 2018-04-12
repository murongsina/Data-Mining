function [ MAE, RMSE, SSE, SSR, SST ] = Statistics(y, yTest)
%STATISTICS 此处显示有关此函数的摘要
% 统计数据
%   此处显示详细说明

    y_bar = mean(yTest);
    E = yTest-y;
    E2 = E.^2;
    MAE = mean(abs(E));
    RMSE = sqrt(mean(E2));
    SSE = sum(E2);
    SST = sum((yTest-y_bar).^2);
    SSR = sum((y-y_bar).^2);
end
