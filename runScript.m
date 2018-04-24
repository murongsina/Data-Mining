% LabMTLClf = LabMTLClf';
% for i = [1 3 4 5]
%     LabMTLClf(i).X = LabMTLClf(i).X';
%     LabMTLClf(i).Y = LabMTLClf(i).Y';
%     LabMTLClf(i).ValInd = LabMTLClf(i).ValInd';
% end
% LabMTLClf = LabMTLClf;
% save('./datasets/LabMTLClf.mat', 'LabMTLClf');

[X, Y] = MTLData(12, 50, 40);