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

load('MTL_UCI5.mat');

IParams = CreateParams(CParams{10});
Error = cell(27, 1);
Result = zeros(27, 3);
for i = [2:6]
    D = MTL_UCI5(i);
    A = load(['RMTL-', D.Name,'.mat']);
    B = load(['SSR_RMTL-', D.Name,'.mat']);
    C = std(A.CVStat-B.CVStat);
    T = mean(A.CVTime-B.CVTime, 1)/mean(A.CVTime(:,1));
    E = std(C(:,1));
    if E == 0
        cnt = sum(B.CVRate(:,1)>0);
        avg = mean(B.CVRate(:,1));
        Result(i,:) = [cnt, avg, T(1)];
        fprintf('Success: %d\n', i);
    else
        Error{i} = [mean([A.CVStat(:,1,:), B.CVStat(:,1,:)], 3), C(:,1), B.CVRate];
        fprintf('Error: %d\t%d\t%d\t\n', i, sum(B.CVRate(:,1)>0), E);
    end
end
%%
IDX = find(Error{3,1}(:,3)~=0);
ErrorParams = IParams(IDX);
% 