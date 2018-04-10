images = './images/';
data = './data/';
% 添加搜索路径
addpath(genpath('./model'));
addpath(genpath('./utils'));
addpath(genpath('./utils/params/'));

% 加载数据集和网格搜索参数
load('LabMulti.mat');
load('LabIParams.mat');

% PSVR:56 params 0.05.
% TWSVR:165888 params 98.36.
% TWSVR_Xu:4608 params 1.18.
% MTL_PSVR:392 params 0.09.
% MTL_LS_SVR:392 params 0.23.
% MTL_TWSVR:4608 params 0.63.
% MTL_TWSVR_Xu:4608 params 0.59.
% MTL_TWSVR_Mei:129024 params 14.83.

% 数据集
DataSetIndices = [5 6 7 8 9 10 11];
ParamIndices = [3 5 6 7]; 

% 实验设置
solver = []; % optimoptions('fmincon', 'Display', 'off');
opts = struct('solver', solver);

% 实验开始
fprintf('runGridSearch\n');
for i = DataSetIndices
    DataSet = LabMulti(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    for j = ParamIndices
        Method = IParams{j};
        [ Stat,  CVStat ] = GridSearchCV(@MTL, X, Y, Method, DataSet.TaskNum, DataSet.Kfold, ValInd, opts);
        save([data, DataSet.Name, '-', Method.Name, '.mat'], 'Stat', 'CVStat');
    end
end