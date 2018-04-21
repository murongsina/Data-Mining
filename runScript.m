% % 添加搜索路径
% addpath(genpath('./params'));
% 
% % 初始化参数表
% load('LabIParams-Linear.mat');
% nParams = length(IParams);
% for i = 1 : nParams
%     nParams = GetParamsCount(IParams{i});
%     Method = IParams{i};
%     tic
%     Params = GetParams(Method, 1);
%     Time = toc;
%     fprintf('%s:%d params %.2f.\n', Method.Name, nParams, nParams*Time);
% end

% 转换数据集
% for i =  1 : 18
%     Src = LabReg(i);
%     [ X, Y, ValInd ] = GetMultiTask(Src);
%     Dst.Name = Src.Name;
%     Dst.X = X;
%     Dst.Y = Y;
%     Dst.TaskNum = Src.TaskNum;
%     Dst.Kfold = Src.Kfold;
%     Dst.ValInd = ValInd;
%     LabMTLReg(i) = Dst;
% end
% LabMTLReg = LabMTLReg';
% save('./datasets/LabMTLReg.mat', 'LabMTLReg');

% LabClf = LabClf';
% for i = 1 : 3
%     LabClf(i).X = LabClf(i).X';
%     LabClf(i).Y = LabClf(i).Y';
%     LabClf(i).ValInd = LabClf(i).ValInd';
% end
% LabMTLClf = LabClf;
% save('./datasets/LabMTLClf.mat', 'LabMTLClf');