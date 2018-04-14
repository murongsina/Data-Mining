data = './data/';
images = './images/';

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% 加载数据集和网格搜索参数
load('LabReg.mat');
load('LabIParams.mat');

% 数据集
DataSetIndices = 1 : 14;
ParamIndices = 2 : 11;

% 实验设置
solver = []; % optimoptions('fmincon', 'Display', 'off');
opts = struct('solver', solver);
fd = fopen(['./log/log-', datestr(now, 'yyyymmddHHMM'), '.txt'], 'w');

% 实验开始
fprintf('runGridSearch\n');
for i = DataSetIndices
    DataSet = LabReg(i);
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
                [ Stat, Time, CVStat ] = GridSearchCV(@MTL, X, Y, Method, DataSet.TaskNum, DataSet.Kfold, ValInd, opts);
                save(StatPath, 'Stat', 'Time', 'CVStat');
                fprintf(fd, 'save: %s\n', StatPath);
            catch Exception
                fprintf(fd, 'Exception in %s\n', Name);
            end
        end
    end
end
fclose(fd);