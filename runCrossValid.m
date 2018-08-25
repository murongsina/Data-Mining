Path = './cv/classify/rbf/';
if exist(Path, 'dir') == 0
    mkdir(Path);
end

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% 加载数据集和网格搜索参数
load('MTL_UCI.mat');
load('LabCParams.mat');

DataSets = MTL_UCI;
IParams = CParams;

% 数据集
DataSetIndices = [18];
ParamIndices = [1:11];
BestParams = 144;

% 实验设置
opts = InitOptions('clf', 1, []);

% 实验开始
fprintf('runCrossValid\n');
for i = DataSetIndices
    DataSet = DataSets(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    StatDir = [ Path, int2str(DataSet.Kfold) '-fold/' ];
    if exist(StatDir, 'dir') == 0
        mkdir(StatDir);
    end
    for j = ParamIndices
        Method = IParams{j};
        Name = [DataSet.Name, '-', Method.Name];
        StatPath = [StatDir, Name, '.mat'];
        try
            Params = GetParams(Method, BestParams);
            Params.solver = opts.solver;
            [ OStat, TStat ] = CrossValid(@MTL, X, Y, DataSet.TaskNum, DataSet.Kfold, ValInd, Params, opts);
            save(StatPath, 'OStat', 'TStat');
            fprintf('save: %s\n', StatPath);
        catch Exception
            fprintf('Exception in %s\n', Name);
        end
    end
end