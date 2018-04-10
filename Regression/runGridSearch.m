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
ParamIndices = [4];
% 实验设置
solver = []; % optimoptions('fmincon', 'Display', 'off');
% 实验开始
fprintf('runGridSearch\n');
for i = DataSetIndices
    DataSet = LabUCIReg(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    opts = struct('solver', solver);
    for j = ParamIndices
        Method = OParams{j};
        [ Stat,  CVStat ] = GridSearchCV(@MTL, X, Y, IParams{j}, DataSet.TaskNum, DataSet.Kfold, ValInd, opts);
        save([data, DataSet.Name, '-', Method.Name, '.mat'], 'Stat', 'CVStat');
    end
end