addpath('./utils/');
addpath('./datasets/');

load('LabMulti.mat');

% 数据集
DataSetIndices = 9 : 11;
TaskNum = 4;
Kfold = 3;

% 构造多任务交叉验证
for i = DataSetIndices
    LabMulti(i) = MultiTask( LabMulti(i), TaskNum, Kfold );
end

save('./datasets/LabMulti.mat', 'LabMulti');