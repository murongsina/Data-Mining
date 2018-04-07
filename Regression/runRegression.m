images = './images/';

addpath(genpath('./model'));
addpath(genpath('./utils'));
addpath(genpath('./datasets/'));

load('LabUCIReg.mat');
load('LabIParams.mat');
load('Colors.mat', 'Colors');

% run regression
kernel = struct('kernel', 'rbf', 'p1', 116.2, 'p2', 25, 'p3', 12);

C1 = 12; C2 = 12; C3 = 12; C4 = 12;
eps1 = 0.4; eps2 = 0.4;
opts0 = struct('Name', 'PSVR', 'nu', C1, 'Kernel', kernel);
opts1 = struct('Name', 'TWSVR', 'C1', C1, 'C2', C2, 'C3', C3, 'C4', C4, 'eps1', eps1, 'eps2', eps2, 'Kernel', kernel);
opts2 = struct('Name', 'TWSVR_Xu', 'C1', C1, 'C2', C2, 'eps1', eps1, 'eps2', eps2, 'Kernel', kernel);
opts3 = struct('Name', 'MTL_TWSVR', 'C1', C1, 'C2', C2, 'eps1', eps1, 'eps2', eps2, 'Kernel', kernel);
opts4 = struct('Name', 'MTL_TWSVR_Xu', 'C1', C1, 'C2', C2, 'eps1', eps1, 'eps2', eps2, 'Kernel', kernel);
opts5 = struct('Name', 'MTL_TWSVR_Mei', 'C1', C1, 'C2', C2, 'eps1', eps1, 'eps2', eps2, 'rho', 1.4, 'lambda', 1.4, 'Kernel', kernel);
solver = [];%optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'interior-point');

opts = {opts0, opts1, opts2, opts3, opts4, opts5};

TaskNum = 4;
Kfold = 3;
CVStat = cell(4);
h = figure('Visible', 'on');
% 对每一个数据集
for i = [3 4]
    DataSet = LabUCIReg(i);
    [X, Y, ValInd] = MultiTask(DataSet, TaskNum, Kfold);
    Stat = zeros(4, 4, 4);
    % 对每一组MTL参数
    for j = 1 : 4
        % 多任务学习
        opt = opts{j};
        opt.solver = solver;
        Stat(j,:,:) = CrossValid( @MTL, X, Y, TaskNum, Kfold, ValInd, opt );
    end
    CVStat{i} = Stat;
end