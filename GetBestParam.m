function [ BestParam, Accuracy, L, R ] = GetBestParam(CParams, CVStat, x, y)
%GETBESTPARAM 此处显示有关此函数的摘要
% 得到最佳参数
%   此处显示详细说明

%% 得到参数
IParams = CreateParams(CParams);
%%
Stat = mean(CVStat, 3);
for i = 1:length(IParams)
    IParams(i).Accuracy = Stat(i, 1);
    IParams(i).Std = Stat(i, 2);
end
[Accuracy, IDX] = max(Stat);
%% 得到参数值
X = CParams.(x);
Y = CParams.(y);
Nx = length(X);
Ny = length(Y);
count = Nx*Ny;
L = floor(IDX(1)/count)*count+1;
R = ceil(IDX(1)/count)*count;
Z = reshape([IParams(L:R).Accuracy]', Ny, Nx);
surf(X, Y, Z);

BestParam = IParams(IDX(1));
end

