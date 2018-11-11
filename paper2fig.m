h = figure();
load('MTL_UCI5.mat');
load('Caltech5.mat');
load('MLC5.mat');
load('LabCParams.mat');
labels = {'\nu-TWSVM','SVM','PSVM','LS-SVM','TWSVM','LS-TWSVM','MT-\nu-TWSVM II','MT-\nu-TWSVM I','MTPSVM','MTLS-SVM','DMTSVM','MTL-aLS-SVM','MCTSVM'};
% 单任务学习
STL_IDX = [2 3 4 5 6 1 8 7];
% 多任务学习
MTL_IDX = [9 10 12 11 13 8 7 ];
CUR_IDX = MTL_IDX;
%% Monk
xLabels = {'60', '90', '120', '150', '180', '210', '240', '270', 'All'};
DrawResult(MyStat(CUR_IDX,[2:9,1])'*100, MyTime(CUR_IDX,[2:9 1])'*1000, labels(CUR_IDX), xLabels);

%% ISOLET
xLabels = {'ab', 'cd', 'ef', 'gh', 'ij', 'kl','mn','op'};
DrawResult(MyStat(CUR_IDX,10:17,1)'*100, MyTime(CUR_IDX,10:17)'*1000, labels(CUR_IDX), xLabels);

%% Caltech
xLabels = {'Birds_1','Insects_1','Flowers_1','Mammals_1','Instruments_1','Aircrafts','Balls','Bikes','Birds','Boats','Flowers','Instruments','Plants','Mammals','Vehicles'};
DrawResult(MyStat(CUR_IDX,:,1)'*100, MyTime(CUR_IDX,:)'*1000, labels(CUR_IDX), xLabels, 45);

%% Caltech101
xLabels = {'Birds','Insects','Flowers','Mammals','Instruments'};
DrawResult(MyStat(CUR_IDX,1:5,1)'*100, MyTime(CUR_IDX,1:5)'*1000, labels(CUR_IDX), xLabels, 45);

%% Caltech256
xLabels = {'Aircrafts','Balls','Bikes','Birds','Boats','Flowers','Instruments','Plants','Mammals','Vehicles'};
DrawResult(MyStat(CUR_IDX,6:15,1)'*100, MyTime(CUR_IDX,6:15)'*1000, labels(CUR_IDX), xLabels, 45);

%% Flags
xLabels = {'100', '120', '140', '160', '180'};
DrawResult(MyStat(CUR_IDX,1:5,1)'*100, MyTime(CUR_IDX,1:5)'*1000, labels(CUR_IDX), xLabels);

%% Emotions
xLabels = {'120', '150', '180', '210', '240'};
DrawResult(MyStat(CUR_IDX,6:10,1)'*100, MyTime(CUR_IDX,6:10)'*1000, labels(CUR_IDX), xLabels);