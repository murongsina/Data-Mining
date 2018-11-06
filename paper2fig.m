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
xLabels = {'60', '90', '120', '150', '180', '210', '240', '270'};
DrawResult(MyStat(CUR_IDX,7:14,1)'*100, MyTime(CUR_IDX,7:14)'*1000, labels(CUR_IDX), xLabels);

%% Landmine-foliated
xLabels = {'3', '5', '7', '9', '11', '13', '15'};
DrawResult(MyStat(CUR_IDX,15:21,1)'*100, MyTime(CUR_IDX,15:21)'*1000, labels(CUR_IDX), xLabels);

%% Landmine-deserted
xLabels = {'3', '5', '7', '9', '11', '13'};
DrawResult(MyStat(CUR_IDX,22:27,1)'*100, MyTime(CUR_IDX,22:27)'*1000, labels(CUR_IDX), xLabels);

%% Caltech
xLabels = {'Aircrafts','Balls','Bikes','Birds','Boats','Flowers','Instruments','Plants','Mammals','Vehicles'};
DrawResult(MyStat(CUR_IDX,1:10,1)'*100, MyTime(CUR_IDX,1:10)'*1000, labels(CUR_IDX), xLabels, 45);

%% Flags
xLabels = {'100', '120', '140', '160', '180'};
DrawResult(MyStat(CUR_IDX,1:5,1)'*100, MyTime(CUR_IDX,1:5)'*1000, labels(CUR_IDX), xLabels);