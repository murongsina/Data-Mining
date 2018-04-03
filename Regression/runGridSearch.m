images = '../images/CSVM/GridSearch/';

addpath(genpath('./model'));
addpath(genpath('./utils'));

load('LabUCIReg.mat', 'LabUCIReg');
load('LabIParams.mat', 'IParams');

% 实验用数据集
DataSetIndices = [3 4];
ParamIndices = [1 2 3 4 5];

% 输出结果
Kfold = 5;
nD = length(DataSetIndices);
nP = length(ParamIndices);
Outputs = cell(nD, nP);
solver = optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'interior-point');

% 开启绘图模式
fprintf('runGridSearch\n');
% 对每一个数据集
for i = 1 : nD
    DataSet = LabUCIReg(DataSetIndices(i));
    fprintf('runGridSearch: %s\n', DataSet.Name);
    % 构造多任务数据集
    [X, Y, ValInd] = MultiTask(DataSet, 4, 5);
    % 交叉验证索引
    opts = struct('TaskNum', 4, 'Kfold', 5, 'ValInd', ValInd, 'solver', solver);
    % 对每一种算法
    for j = 1 : nP
        % 网格搜索、交叉验证
        CVStat = GridSearchCV(@MTL, X, Y, IParams{j}, opts);
        % 保存网格搜索交叉验证的结果
        Outputs(i, j) = {
            DataSet.Name, DataSet.Instances, DataSet.Attributes, CVStat
        };
    end
end

% save('runGridSearch.mat', Output);