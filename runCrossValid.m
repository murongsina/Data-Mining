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
load('LabMTLClf.mat');
load('LabCParams.mat');

DataSets = LabMTLClf;
IParams = CParams;

% 数据集
DataSetIndices = [1 2 3 4 5];
ParamIndices = [1:9];
BestParams = 144;

% 实验设置
opts = InitOptions('clf', 0, []);

% 实验开始
fprintf('runCrossValid\n');
for i = DataSetIndices
    DataSet = DataSets(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    for j = ParamIndices
        Method = IParams{j};
        Name = [DataSet.Name, '-', Method.Name];
        StatPath = [Path, Name, '.mat'];
        try
            Params = GetParams(Method, BestParams);
            Params.solver = opts.solver;
            CVStat = CrossValid(@MTL, X, Y, DataSet.TaskNum, DataSet.Kfold, ValInd, Params, opts);
            save(StatPath, 'CVStat');
            fprintf('save: %s\n', StatPath);
        catch Exception
            fprintf('Exception in %s\n', Name);
        end
    end
end