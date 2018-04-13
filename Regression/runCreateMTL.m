addpath(genpath('./datasets'));
addpath(genpath('./utils'));

load('LabReg.mat');

% 数据集
DataSetIndices = 1:5;
TaskNum = 2;
Kfold = 5;

% 构造多任务交叉验证
Size = zeros(14, 1);
for i = DataSetIndices
    LabReg(i) = MultiTask( LabReg(i), TaskNum, Kfold );
    % 计算数据集任务大小
    [ m, n ] = size(LabReg(i).Data);
    TaskNum = LabReg(i).TaskNum;
    Kfold = LabReg(i).Kfold;
    Size(i,:) = m*n*TaskNum*Kfold;
end

% 按任务大小排序
[ ~, IDX ] = sort(Size);
LabReg = LabReg(IDX);
save('./datasets/LabReg.mat', 'LabReg');