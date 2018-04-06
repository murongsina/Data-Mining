images = './images/';

addpath(genpath('./model'));
addpath(genpath('./utils'));
addpath(genpath('./datasets/'));

load('LabUCIReg.mat');
load('LabIParams.mat');
load('Colors.mat', 'Colors');

% run regression
kernel = struct('kernel', 'rbf', 'p1', 116.2, 'p2', 25, 'p3', 12);

C1 = 120; C2 = 120; C3 = 120; C4 = 120;
eps1 = 111.4; eps2 = 111.4;
opts1 = struct('Name', 'TWSVR', 'C1', C1, 'C2', C2, 'C3', C3, 'C4', C4, 'eps1', eps1, 'eps2', eps2, 'Kernel', kernel);
opts2 = struct('Name', 'TWSVR_Xu', 'C1', C1, 'C2', C2, 'eps1', eps1, 'eps2', eps2, 'Kernel', kernel);
opts3 = struct('Name', 'MTL_TWSVR', 'C1', C1, 'C2', C2, 'eps1', eps1, 'eps2', eps2, 'Kernel', kernel);
opts4 = struct('Name', 'MTL_TWSVR_Xu', 'C1', C1, 'C2', C2, 'eps1', eps1, 'eps2', eps2, 'Kernel', kernel);
opts5 = struct('Name', 'MTL_TWSVR_Mei', 'C1', C1, 'C2', C2, 'eps1', eps1, 'eps2', eps2, 'rho', 1.4, 'lambda', 1.4, 'Kernel', kernel);
solver = [];%optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'interior-point');

opts = {opts1, opts2, opts3, opts4, opts5};

perf = zeros(5, 9, 4);
% h = figure('Visible', 'on');
% 对每一个数据集
for i = [3 4]
    DataSet = LabUCIReg(i);
    [X, Y, ~] = MultiTask(DataSet, 8, 4);
%     [X, Y] = Normalize(X, Y);
    % 对每一组MTL参数
    for j = 1 : 5
        % 多任务学习
        opt = opts{j};
        opt.solver = solver;
        [ y, Time] = MTL(X, Y, X, opt);
%         clf(h);
        % 绘制多任务学习结果
        perf(j, 9, i) = Time;
        for t = 1 : 8
            perf(j, t, i) = mse(y{t}-Y{t}, Y(t), y(t));
%             PlotCurve( X{t}, Y{t}, ['Task-', num2str(t)], 2, 2, t, 1, Colors(1,:));
%             PlotCurve( X{t}, y{t}, ['Task-', num2str(t)], 2, 2, t, 2, Colors(2,:));
        end
        % 保存图片
%         name = ['runRegression-', DataSet.Name, '-', opt.Name];
%         saveas(h, [images, name, '.png']);
%         savefig(h, [images, name]);
    end
end