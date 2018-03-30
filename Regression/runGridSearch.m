images = '../images/CSVM/GridSearch/';

addpath(genpath('./model'));
addpath(genpath('./utils'));

load('LabUCIReg.mat', 'LabUCIReg');
load('LabIParams.mat', 'IParams');

% 实验用数据集
DataSetIndices = [3 4];
ParamIndices = [1];
% 输出结果
Kfold = 5;
nD = length(DataSetIndices);
nP = length(ParamIndices);
Outputs = cell(nD, 8);

% 设置为多任务学习器
Learner = @MTL;

% 开启绘图模式
fprintf('runGridSearch\n');
% 对每一个数据集
for i = 1 : nD
    DataSet = LabUCIReg(DataSetIndices(i));
    fprintf('runGridSearch: %s\n', DataSet.Name);
%     [X, Y] = SplitDataLabel(DataSet.Data);
    % 构造多任务数据集
    [X, Y] = MultiTask(DataSet, 4);
    % 交叉验证索引
    ValInd = CrossValInd( DataSet.Instances, Kfold );
    % 对每一组实验参数
    for j = 1 : nP
        % 选择实验参数
        Params = IParams{j};
        % 网格搜索、交叉验证
        Outputs = GridSearchCV(Learner, X, Y, ValInd, Params, Kfold);
        % 保存网格搜索交叉验证的结果
        Outputs(i, j) = {
            DataSet.Name, DataSet.Instances, DataSet.Attributes, Output
        };
    end
end

% save('runGridSearch.mat', Output);