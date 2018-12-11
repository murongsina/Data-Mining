clear;
clc;

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% 实验设置
opts = InitOptions('clf', 1, [], 0);
% 核函数
kernel = 'Poly';
switch(kernel)
    case 'Poly'
        Src = './data/classify/poly/';
        Dst = './lab/classify/poly/';
        load('LabCParams-Poly.mat');
    otherwise
        Src = './data/classify/rbf/';
        Dst = './lab/classify/rbf/';
        load('LabCParams.mat');
end

% 统计实验数据
datasets = {'Caltech5', 'MTL_UCI5', 'MLC5'};
for i = 1 : length(datasets)
    load(datasets{i});
    [ MyStat, MyTime, MyRank ] = MyStatistics(eval(datasets{i}), CParams, Src, Dst, opts);
    path = ['MyStat-', datasets{i}, '-', kernel, '.mat'];
    save(path, 'MyStat', 'MyTime', 'MyRank');
    fprintf(['save: ', path, '\n']);
end