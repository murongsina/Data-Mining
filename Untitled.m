% Task = [];
% ValInd = [];
% for i = 1 : 139
%     L = i*ones(size(Y{i}));
%     Task = cat(1, Task, L);
%     V = crossvalind('Kfold', L, 5);
%     ValInd = cat(1, ValInd, V);
% end
% XX = cell2mat(X');
% YY = cell2mat(Y');
% load('LabReg.mat');
% U = LabReg(3).Data;
% V = U;
% kernel = struct('kernel', 'linear', 'p1', 12.2);
% n = 100;
% Time1 = zeros(n, 1);
% Time2 = zeros(n, 1);
% H = @Kernel;
% for i = 1 : n
%     tic;
%     Kernel(U, V, kernel);
%     Time1(i) = toc;
%     tic;
%     feval(@Kernel, U, V, kernel);
%     Time2(i) = toc;
% end
% mean(Time1)
% mean(Time2)
profile on
profile clear
runCrossValid;
profreport('runCrossValid');