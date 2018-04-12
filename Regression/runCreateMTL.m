addpath('./utils/');
addpath('./datasets/');

load('LabReg.mat');

% 数据集
DataSetIndices = 13;
TaskNum = 20;
Kfold = 3;

% 构造多任务交叉验证
for i = DataSetIndices
    LabReg(i) = MultiTask( LabReg(i), TaskNum, Kfold );
end

save('./datasets/LabReg.mat', 'LabReg');