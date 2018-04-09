images = './images/';

addpath(genpath('./model'));
addpath(genpath('./utils'));
addpath(genpath('./datasets/'));

load('LabUCIReg.mat');
load('LabParams.mat');
load('Colors.mat', 'Colors');

%optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'interior-point');

opts = {opts1, opts2, opts3, opts4, opts5, opts6, opts7};

TaskNum = 4;
Kfold = 3;
DataSet = LabUCIReg(2);
[X, Y, ValInd] = MultiTask(DataSet, TaskNum, Kfold);
Stat = zeros(7, 4, TaskNum);
% 对每一组MTL参数
for j = [ 2 3 4 ]
    % 多任务学习
    opt = opts{j};
    opt.solver = solver;
    [X, Y] = Normalize(X, Y);
    Stat(j,:,:) = CrossValid( @MTL, X, Y, TaskNum, Kfold, ValInd, opt );
end