images = './images/';
data = './data/';
% 添加搜索路径
addpath(genpath('./model'));
addpath(genpath('./utils'));
% 加载数据集和网格搜索参数
load('LabUCIReg.mat');
load('LabParams.mat');
% 数据集
DataSetIndices = [3 4];
ParamIndices = [4 5];
CVIndices = [1 4 9];
% 实验设置
solver = []; % optimoptions('fmincon', 'Display', 'off');
% 实验开始
fprintf('runRegression\n');
DataSet = LabUCIReg(3);
for i = ParamIndices
    TParams = IParams{3, 1};
    % 对每一组MTL参数
    for j = [ 2 3 4 ]
        % 多任务学习
        Params = {i, 1};
        Params.solver = solver;
        Stat(i,:,:) = CrossValid( @MTL, X, Y, DataSet.TaskNum, DataSet.Kfold, ValInd, Params );
    end
end