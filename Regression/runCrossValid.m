images = './images/';
data = './data/';

% 添加搜索路径
addpath(genpath('./model'));
addpath(genpath('./utils'));

% 加载数据集和网格搜索参数
load('LabUCIReg.mat');
load('LabParams.mat');

% 数据集
DataSetIndices = [3];
ParamIndices = [5];
BestParams = 85;

% 实验设置
solver = []; % optimoptions('fmincon', 'Display', 'off');
opts = struct('solver', solver);

% 实验开始
fprintf('runGridSearch\n');
for i = DataSetIndices
    DataSet = LabUCIReg(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    for j = ParamIndices
        Method = OParams{j};
        Params = IParams{j}(BestParams);
        CVStat = CrossValid(@MTL, X, Y, DataSet.TaskNum, DataSet.Kfold, ValInd, Params);
        save([data, DataSet.Name, '-', Method.Name, '-Best.mat'], 'CVStat');
    end
end