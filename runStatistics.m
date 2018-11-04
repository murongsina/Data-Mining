clear;
clc;

Src = './data/classify/rbf/';
Dst = './lab/classify/rbf/';

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% 实验设置
opts = InitOptions('clf', 1, []);

%% Caltech5
load('Caltech5.mat');
load('LabCParams.mat');
[ MyStat, MyTime, MyRank ] = MyStatistics(Caltech5([6:15]), CParams, Src, Dst, opts);
save('MyStat-Caltech5-RBF.mat', 'MyStat', 'MyTime', 'MyRank');

%% MTL_UCI5
load('MTL_UCI5.mat');
load('LabCParams.mat');
[ MyStat, MyTime, MyRank ] = MyStatistics(MTL_UCI5, CParams, Src, Dst, opts);
save('MyStat-MTL_UCI5-RBF.mat', 'MyStat', 'MyTime', 'MyRank');

%% MLC5
load('MLC5.mat');
load('LabCParams.mat');
[ MyStat, MyTime, MyRank ] = MyStatistics(MLC5, CParams, Src, Dst, opts);
save('MyStat-MLC5-RBF.mat', 'MyStat', 'MyTime', 'MyRank');