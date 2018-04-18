datasets = '../images/';

% LR(LR(:,3)==0,3) = -1;
% run(LR(:,1:2), LR(:,3), 'rbf', 12800.5, [datasets, 'SVM-LR.png']);


datasets = '../datasets/mnist/';
[x, y] = load_mnist([datasets, 't10k']);
x = x.';
idx0 = find(y(:,1)==0);
idx1 = find(y(:,1)~=0);
y(idx0, 1) = -1;
y(idx1, 1) = 1;
run(x(1:500,:), y(1:500,:), 'rbf', 24.5);

