addpath(genpath('./datasets'));
addpath(genpath('./utils'));

% load('LabReg.mat');

% 数据集
DataSetIndices = 1:5;
TaskNum = 2;
Kfold = 5;

% 构造多任务交叉验证
for i = DataSetIndices
    LabReg(i) = MultiTask( LabReg(i), TaskNum, Kfold );
end

save('./datasets/LabReg.mat', 'LabReg');