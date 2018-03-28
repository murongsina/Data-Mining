datasets = '../datasets/artificial/';

% 数据集
% Datasets = {
%     Sine(4000)
%     Grid(4000, 2, 2, 1)
%     Ring(4000, 2, 2)
% };

% 数据集名称
% DatasetNames = {
%     'Sine_4000', 'Grid_4000', 'Ring_4000'
% };

% 保存数据集
file = [datasets, 'Datasets.mat'];
save(file, 'Datasets');