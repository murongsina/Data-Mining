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
IParams = CreateParams(CParams{12});
Params = struct2cell(IParams)';
Result = cell(54, 1);
State = zeros(54, 8);
Error = cell(54, 1);
for i = [1:54]
    D = DataSets(i);
    A = load(['IRMTL-', D.Name,'.mat']);
    B = load(['SSR_IRMTL-', D.Name,'.mat']);
    T = mean(A.CVTime-B.CVTime, 1)/mean(A.CVTime(:,1));
    C = permute(A.CVStat(:,1,:)==B.CVStat(:,1,:), [1 3 2]);
    % Result
    IDX = B.CVRate>0;
    cnt = sum(IDX, 1);
    avg0 = mean(B.CVRate, 1);
    avg1 = sum(B.CVRate, 1)./cnt;
    Result{i} = [mean([A.CVStat(:,1,:), B.CVStat(:,1,:)], 3), B.CVRate];
    if mean(C(:)) == 1
        fprintf('Success: %d\n', i);
        State(i,:) = [cnt, avg0(:,1)/avg0(:,2), avg0, avg1, T(1)];
    else
        fprintf('Error: %d\n', i);
        Error(i,:) = [cnt, avg0(:,1)/avg0(:,2), avg0, avg1, T(1)];
    end
end
%%
EE = Error{49,1};
IDX = find(EE(:,2)~=EE(:,1));
ErrorParams = IParams(IDX);
E=EE(IDX,:);
% 