clear
clc
kernel = 'RBF';
switch(kernel)
    case 'Poly'
        Src = ['./data/ssr/poly/'];
        load('LabCParams-Poly.mat');
    otherwise
        Src = ['./data/ssr/rbf/'];
        load('LabCParams.mat');
end
addpath(genpath(Src));

load('Caltech5.mat');
load('MTL_UCI5.mat');
load('MLC5.mat');

DataSets = [MTL_UCI5; Caltech5; MLC5];
IParams = CreateParams(CParams{10});
Success = cell(54, 1);
Error = cell(54, 1);
Result = zeros(54, 4);
for i = [49]
    D = DataSets(i);
    A = load(['RMTL-', D.Name,'.mat']);
    B = load(['SSR_RMTL-', D.Name,'.mat']);
    T = mean(A.CVTime-B.CVTime, 1)/mean(A.CVTime(:,1));
    C = permute(A.CVStat(:,1,:)==B.CVStat(:,1,:), [1 3 2]);
    % Result
    IDX = B.CVRate(:,1)>0;
    cnt = sum(IDX);
    avg0 = mean(B.CVRate(:,1));
    avg1 = mean(B.CVRate(IDX,1));
    Result(i,:) = [cnt, avg0, avg1, T(1)];
    if std(C(:)) == 0 && mean(C(:)) == 1
        fprintf('Success: %d\n', i);
    else
        Error{i} = [mean([A.CVStat(:,1,:), B.CVStat(:,1,:)], 3), B.CVRate];
        fprintf('Error: %d\n', i);
    end
end
%%
EE = Error{49,1};
IDX = find(EE(:,2)~=EE(:,1));
ErrorParams = IParams(IDX);
E=EE(IDX,:);
% 