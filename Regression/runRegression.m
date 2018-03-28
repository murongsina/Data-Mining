% run regression
kernel = struct('kernel', 'rbf', 'p1', 12.2);
params = struct('C1', 2, 'C2', 2, 'eps1', 0.4, 'eps2', 0.4, 'Kernel', kernel);
reg = MTL_TWSVR(params);

perf = zeros(3, 4);
h = figure('Visible', 'on');
for i = [3]
    DataSet = LabUCIReg(i);
    [X, Y] = MultiTask(DataSet, 4);
    [X, Y] = Normalize(X, Y);
    reg = reg.Fit(X, Y);
    y = reg.Predict(X);
    clf(h);
    for j = 1 : 4
        perf(i, j) = mse(y{j}-Y{j}, Y{j}, y{j});
        PlotCurve( X{j}, Y{j}, ['Tast-', num2str(j)], 2, 2, j, 1, Colors(1,:));
        PlotCurve( X{j}, y{j}, ['Tast-', num2str(j)], 2, 2, j, 2, Colors(2,:));
    end
    hold on
    saveas(h, ['runRegression-', DataSet.Name ,'.png']);
end

savefig('runRegression');