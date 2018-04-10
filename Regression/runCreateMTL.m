load('LabUCIReg.mat');

% 数据集
DataSetIndices = 1: 17;
TaskNum = 5;
Kfold = 3;

% 构造多任务交叉验证
for i = DataSetIndices
    UCI(i) = MultiTask( UCI(i), TaskNum, Kfold );
end

save('LabMulti.mat', 'LabMulti');