images = './images/';

addpath(genpath('./model'));
addpath(genpath('./utils'));
addpath(genpath('./datasets/'));

load('LabUCIReg.mat', 'LabUCIReg');
load('LabIParams.mat', 'LabIParams');
load('Colors.mat', 'Colors');

% run regression
kernel = struct('kernel', 'rbf', 'p1', 36.2);

C1 = 111; C2 = 111; C3 = 111; C4 = 111;
eps1 = 0.51; eps2 = 0.51;
opts1 = struct('Name', 'TWSVR', 'C1', C1, 'C2', C2, 'C3', C3, 'C4', C4, 'eps1', eps1, 'eps2', eps2, 'Kernel', kernel);
opts2 = struct('Name', 'TWSVR_Xu', 'C1', C1, 'C2', C2, 'C3', C3, 'C4', C4, 'eps1', eps1, 'eps2', eps2, 'Kernel', kernel);
opts3 = struct('Name', 'MTL_TWSVR', 'C1', C1, 'C2', C2, 'eps1', eps1, 'eps2', eps2, 'Kernel', kernel);
opts4 = struct('Name', 'MTL_TWSVR_Xu', 'C1', C1, 'C2', C2, 'eps1', eps1, 'eps2', eps2, 'Kernel', kernel);
solver = optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'interior-point');

opts = {opts1, opts2, opts3, opts4};

perf = zeros(4, 5);
% h = figure('Visible', 'on');
% 对每一个数据集
for i = [4]
    DataSet = LabUCIReg(i);
    [X, Y, ~] = MultiTask(DataSet, 4, 5);
%     [X, Y] = Normalize(X, Y);
    % 对每一组MTL参数
    for j = [1 2 3 4]
        % 多任务学习
        opt = opts{j};
        opt.solver = solver;
        [ y, Time] = MTL(X, Y, X, opt);
%         clf(h);
        % 绘制多任务学习结果
        perf(j, 5) = Time;
        for t = 1 : 4
            perf(j, t) = mse(y{t}-Y{t});
%             PlotCurve( X{t}, Y{t}, ['Task-', num2str(t)], 2, 2, t, 1, Colors(1,:));
%             PlotCurve( X{t}, y{t}, ['Task-', num2str(t)], 2, 2, t, 2, Colors(2,:));
        end
        % 保存图片
%         name = ['runRegression-', DataSet.Name, '-', opt.Name];
%         saveas(h, [images, name, '.png']);
%         savefig(h, [images, name]);
    end
end