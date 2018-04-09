images = './images/';

addpath(genpath('./model'));
addpath(genpath('./utils'));

load('LabUCIReg.mat', 'LabUCIReg');
load('LabIParams.mat', 'IParams');

% 数据集
DataSetIndices = [3];
ParamIndices = [4];
% 实验设置
TaskNum = 8;
Kfold = 3;
solver = []; % optimoptions('fmincon', 'Display', 'off');
% 输出结果
nD = length(LabUCIReg);
nP = length(IParams);
Outputs = cell(nD, nP);

% 开启绘图模式
fprintf('runGridSearch\n');
% 对每一个数据集
for i = DataSetIndices
    DataSet = LabUCIReg(i);
    fprintf('runGridSearch: %s\n', DataSet.Name);
    % 构造多任务数据集
    [X, Y, ValInd] = MultiTask(DataSet, TaskNum, Kfold);
    [X, Y] = Normalize(X, Y);
    % 交叉验证索引
    opts = struct('solver', solver);
    % 对每一种算法
    for j = ParamIndices
        % 网格搜索、交叉验证
        CVStat = GridSearchCV(@MTL, X, Y, IParams{j}, TaskNum, Kfold, ValInd, opts);
        % 保存网格搜索交叉验证的结果
        Output = {DataSet.Name, DataSet.Instances, DataSet.Attributes, CVStat};
        Outputs{i, j} = Output;
    end
end

% save('runGridSearch.mat', Output);