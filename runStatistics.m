clear;
clc;

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% 实验设置
opts = InitOptions('clf', 1, [], 0, 2);
% 核函数
types = {'classify', 'regression', 'ssr'};
type = types{1};
kernel = 'RBF';
switch(kernel)
    case 'Poly'
        Src = ['./data/', type, '/poly/'];
        Dst = ['./lab/', type, '/poly/'];
        load('LabCParams-Poly.mat');
    otherwise
        Src = ['./data/', type, '/rbf/'];
        Dst = ['./lab/', type, '/rbf/'];
        load('LabCParams.mat');
end

Path = ['./results/', type, '/'];
if exist(Path, 'dir') == 0
    mkdir(Path);
end

% 统计实验数据
datasets = {'Caltech5', 'MTL_UCI5', 'MLC5'};
for i = 1 : length(datasets)
    load(datasets{i});
    [ MyStat, MyTime, MyRank ] = MyStatistics(eval(datasets{i}), CParams, Src, Dst, opts);
    path = [Path, 'MyStat-', datasets{i}, '-', kernel, '.mat'];
    save(path, 'MyStat', 'MyTime', 'MyRank');
    fprintf(['save: ', path, '\n']);
end