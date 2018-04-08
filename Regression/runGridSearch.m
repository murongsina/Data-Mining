images = './images/';

addpath(genpath('./model'));
addpath(genpath('./utils'));

load('LabUCIReg.mat', 'LabUCIReg');
load('LabIParams.mat', 'IParams');

% 数据集
DataSetIndices = [1 3 4];
ParamIndices = [1 2 3 4 5 6 7 8];
% 实验设置
TaskNum = 4;
Kfold = 5;
solver = []; % optimoptions('fmincon', 'Display', 'off');
% 输出结果
nD = length(DataSetIndices);
nP = length(ParamIndices);
Outputs = cell(nD, nP);

% 开启绘图模式
fprintf('runGridSearch\n');
% 对每一个数据集
for i = 1 : nD
    DataSet = LabUCIReg(DataSetIndices(i));
    fprintf('runGridSearch: %s\n', DataSet.Name);
    % 构造多任务数据集
    [X, Y, ValInd] = MultiTask(DataSet, TaskNum, Kfold);
    [X, Y] = Normalize(X, Y);
    % 交叉验证索引
    opts = struct('solver', solver);
    % 对每一种算法
    for j = 1 : nP
        % 网格搜索、交叉验证
        CVStat = GridSearchCV(@MTL, X, Y, IParams{j}, TaskNum, Kfold, ValInd, opts);
        % 保存网格搜索交叉验证的结果
        Output = struct(DataSet.Name, DataSet.Instances, DataSet.Attributes, CVStat);
        Outputs(i, j) = Output;
    end
end

% save('runGridSearch.mat', Output);