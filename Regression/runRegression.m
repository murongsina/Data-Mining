images = './images/';

addpath(genpath('./model'));
addpath(genpath('./utils'));
addpath(genpath('./datasets/'));

load('LabUCIReg.mat');
load('LabIParams.mat');
load('Colors.mat', 'Colors');

% run regression
kernel = struct('kernel', 'rbf', 'p1', 32.4);

C1 = 10; C2 = 10; C3 = 10; C4 = 10;
eps1 = 1; eps2 = 1;
lambda = 16; gamma = 16;
opts1 = struct('Name', 'PSVR', 'nu', C1, 'kernel', kernel);
opts2 = struct('Name', 'TWSVR', 'C1', C1, 'C2', C2, 'C3', C3, 'C4', C4, 'eps1', eps1, 'eps2', eps2, 'kernel', kernel);
opts3 = struct('Name', 'TWSVR_Xu', 'C1', C1, 'C2', C2, 'eps1', eps1, 'eps2', eps2, 'kernel', kernel);
opts4 = struct('Name', 'MTL_LS_SVR', 'lambda', lambda, 'gamma', gamma, 'kernel', kernel);
opts5 = struct('Name', 'MTL_TWSVR', 'C1', C1, 'C2', C2, 'eps1', eps1, 'eps2', eps2, 'kernel', kernel);
opts6 = struct('Name', 'MTL_TWSVR_Xu', 'C1', C1, 'C2', C2, 'eps1', eps1, 'eps2', eps2, 'kernel', kernel);
opts7 = struct('Name', 'MTL_TWSVR_Mei', 'C1', C1, 'C2', C2, 'eps1', eps1, 'eps2', eps2, 'rho', 1.4, 'lambda', 1.4, 'kernel', kernel);
solver = [];
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