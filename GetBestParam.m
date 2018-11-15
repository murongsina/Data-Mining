function [ BestParam, Accuracy, Result, L, R ] = GetBestParam(CParams, CVStat, x, y)
%GETBESTPARAM 此处显示有关此函数的摘要
% 得到最佳参数
%   此处显示详细说明

%% 得到参数
Result = CreateParams(CParams);
%%
INDICES = {'Accuracy', 'Precision', 'Recall', 'F1'};
Stat = mean(CVStat, 3);
for i = 1:length(Result)
    for j = 1: 4
        Result(i).(INDICES{j}) = Stat(i, j);
    end
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
Z = reshape([Result(L:R).Accuracy]', Ny, Nx);
surf(X, Y, Z);

BestParam = Result(IDX(1));
end

