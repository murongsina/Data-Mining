clear
clc
kernel = 'RBF';
switch(kernel)
    case 'Poly'
        Src = './data/ssr/poly/';
        load('LabCParams-Poly.mat');
    otherwise
        Src = './data/ssr/rbf/';
        load('LabCParams.mat');
end
addpath(genpath(Src));

load('Caltech5.mat');
load('MTL_UCI5.mat');
load('MLC5.mat');

DataSets = [MTL_UCI5; Caltech5; MLC5];
IParams = CreateParams(CParams{10});
Error = cell(54, 1);
Result = zeros(54, 3);
for i = [1:18]
    D = DataSets(i);
    A = load(['RMTL-', D.Name,'.mat']);
    B = load(['SSR_RMTL-', D.Name,'.mat']);
    C = mean(A.CVStat==B.CVStat, 1);
    T = mean(A.CVTime-B.CVTime, 1)/mean(A.CVTime(:,1));
    E = mean(C, 3);
    if E(1) == 1.0
        cnt = sum(B.CVRate(:,1)>0);
        avg = mean(B.CVRate(:,1));
        Result(i,:) = [cnt, avg, T(1)];
        fprintf('Success: %d\n', i);
    else
        Error{i} = [mean([A.CVStat(:,1,:), B.CVStat(:,1,:)], 3), B.CVRate];
        fprintf('Error: %d\t%d\t%.2f\t\n', i, sum(B.CVRate(:,1)>0), E(1,1,1));
    end
end
%%
IDX = find(Error{3,1}(:,3)~=0);
ErrorParams = IParams(IDX);
% 