load('LabUCIReg.mat');

% 数据集
DataSetIndices = [1 2 3 4 5];
TaskNum = 5;
Kfold = 3;

% 构造多任务交叉验证
for i = DataSetIndices
    LabUCIReg(i) = MultiTask( LabUCIReg(i), TaskNum, Kfold );
end

save('LabUCIReg.mat', 'LabUCIReg');