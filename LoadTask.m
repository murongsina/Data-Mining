clear
clc
addpath(genpath('./data'));
load('LabCParams.mat');
load('MTL_UCI5.mat');

IParams = CreateParams(CParams{10});
%%
Error = cell(10, 1);
for i = [2:9]
    D = MTL_UCI5(i);
    A = load(['RMTL-', D.Name,'.mat']);
    B = load(['SSR_RMTL-', D.Name,'.mat']);
    C = mean(A.CVStat-B.CVStat, 3);
    E = sum(C(:,1));
    if E > 0
        Error{i} = [mean([A.CVStat(:,1,:), B.CVStat(:,1,:)], 3), C(:,1), B.CVRate];
        fprintf('Total %.4f Error in %d:\n', E, i);
    end
end
%%
IDX = find(Error{4,1}(:,3)>0);
ErrorParams = IParams(IDX);
% 