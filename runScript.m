% LabMTLClf = LabMTLClf';
% for i = [1 3 4 5]
%     LabMTLClf(i).X = LabMTLClf(i).X';
%     LabMTLClf(i).Y = LabMTLClf(i).Y';
%     LabMTLClf(i).ValInd = LabMTLClf(i).ValInd';
% end
% LabMTLClf = LabMTLClf;
% save('./datasets/LabMTLClf.mat', 'LabMTLClf');

% [X, Y] = MTLData(12, 50, 40);

load LabMTL.mat
load MTL_UCI.mat
% Name = 'UCI-isolet-ab';
% Src = LabMTL(1);
% X = Src.X;
% Y = Src.Y;
% % reduce dimensions
% [X, CNT] = cellcat(X, 1);
% X = PCA(X, 0.98);
% X = mat2cell(X, CNT);
% % reduce dataset
% [Xr, Yr] = ReduceMTL(X, Y, [1 2 3 4 5], [1 2]);
% % reduce dimensions
% % [Xr, CNT] = cellcat(Xr, 1);
% % Xr = PCA(Xr, 0.98);
% % Xr = mat2cell(Xr, CNT);
% % create dataset
% Dst = CreateMTL(Name, Xr, Yr, ['a', 'b'], 3);
% MTL_UCI = cat(1, MTL_UCI, Dst);
% save MTL_UCI.mat MTL_UCI;

% Monk
% for count = 60:20:180
%     Name = sprintf('UCI-Monk-%d', count);
%     Src = LabMTL(3);
%     Dst = MyReduce(Src, Name, [1 2 3], [0,1], count, false, 3);
%     MTL_UCI = cat(1, MTL_UCI, Dst);
% end
% save MTL_UCI.mat MTL_UCI;
% 
% Src = LabMTL(3);
% Dst = MyReduce(Src, 'UCI-Monk-40', [1 2 3], [0,1], 40, false, 3);
% MTL_UCI = cat(1, MTL_UCI, Dst);
% save MTL_UCI.mat MTL_UCI;