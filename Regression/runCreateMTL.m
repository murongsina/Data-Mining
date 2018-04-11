addpath('./utils/');
load('LabSVMReg.mat');

% 数据集
DataSetIndices = 1: 5;
TaskNum = 5;
Kfold = 3;

% 构造多任务交叉验证
for i = DataSetIndices
    LabSVMReg(i) = MultiTask( LabSVMReg(i), TaskNum, Kfold );
end

save('LabSVMReg.mat', 'LabSVMReg');