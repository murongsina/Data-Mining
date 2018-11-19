load('LabMCL.mat');
Datasets = [];
for i = 1 : 14
    D = LabMCL(i);
    nclass = length(D.Labels);
    opts = struct('nclass', nclass, 'labels', D.Labels, 'count', 0, 'mode', 'RvO');
    [ Xr, Yr ] = MC2MT(D.X, D.Y, opts);
    Dataset = MyReduce(Xr, Yr, D.Name, 1:nclass-1, [0,1], 0, true, 3);
    Datasets = cat(1, Datasets, Dataset);
end