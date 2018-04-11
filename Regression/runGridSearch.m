images = './images/';
data = './data/';

% 添加搜索路径
addpath(genpath('./model'));
addpath(genpath('./utils'));
addpath(genpath('./utils/params/'));

% 加载数据集和网格搜索参数
load('LabUCIReg.mat');
load('LabIParams.mat');

% PSVR:28 params 0.04.
% TWSVR:82944 params 38.24.
% TWSVR_Xu:2304 params 0.35.
% MTL_PSVR:196 params 0.10.
% MTL_LS_SVR:196 params 0.14.
% MTL_TWSVR:2304 params 0.22.
% MTL_TWSVR_Xu:2304 params 0.13.
% MTL_TWSVR_Mei:64512 params 3.84.

% 数据集
DataSetIndices = [3 4 10 11 12];
ParamIndices = [6 7];

% 实验设置
solver = []; % optimoptions('fmincon', 'Display', 'off');
opts = struct('solver', solver);
fd = fopen(['log-', datestr(now, 'yyyymmddHHMM'), '.txt'], 'w');
% 实验开始
fprintf('runGridSearch\n');
for i = DataSetIndices
    DataSet = LabUCIReg(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    for j = ParamIndices
        Method = IParams{j};
        Name = [DataSet.Name, '-', Method.Name];
        StatPath = [data, Name, '.mat'];
        if exist(StatPath, 'file') == 2
            fprintf(fd, 'skip: %s\n', StatPath);
            continue;
        else
            try
                [ Stat,  CVStat ] = GridSearchCV(@MTL, X, Y, Method, DataSet.TaskNum, DataSet.Kfold, ValInd, opts);
                save(StatPath, 'Stat', 'CVStat');
                fprintf(fd, 'save: %s\n', StatPath);
            catch Exception
                fprintf(fd, 'Exception in %s\n', Name);
            end
        end
    end
end
fclose(fd);