cv = './cv/';
images = './images/';

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% 加载数据集和网格搜索参数
load('LabMTLReg.mat');
load('LabRParams.mat');
DataSets = LabMTLReg;
IParams = RParams;

% 数据集
DataSetIndices = [1];
ParamIndices = [1:14];
BestParams = 1;

% 实验设置
solver = [];
opts = struct('solver', solver, 'Statistics', @RegStat, 'IndexCount', 4);

% 实验开始
fprintf('runCrossValid\n');
for i = DataSetIndices
    DataSet = LabMTLReg(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetClfMTL(DataSet);
    [ X ] = Normalize(X);
    for j = ParamIndices
        Method = IParams{j};
        Name = [DataSet.Name, '-', Method.Name];
        StatPath = [cv, Name, '.mat'];
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