% path = './data/';
% Labs = {
%     'a1a.mat', 'Cancer_pan.mat', 'EGGEYESTATE.mat', 'ijcnn1.mat',...
%     'MAGICGamma_pan.mat', 'mushrooms.mat', 'musk.mat', 'pima_pan.mat', ...
%     'seismic_bumps.mat', 'skin_nonskin.mat', 'spambase.mat', 'waveform.mat', 'MNIST.mat'
% };

% Names = {
%     'Balance', 'Car', 'Contraceptive', 'Dermatology', 'Ecoli',...
%     'Glass', 'Hayes', 'Image', 'Iris', 'PageBlocks',...
%     'Seeds', 'Soybean', 'Teach', 'Wine',...
%     'a1a', 'Cancer_pan', 'EGGEYESTATE', 'ijcnn1', 'MAGICGamma_pan',...
%     'mushrooms', 'musk', 'pima_pan', 'seismic_bumps', 'skin_nonskin',...
%     'spambase', 'waveform'
% };
% DataSets = {    
%     Balance, Car, Contraceptive, Dermatology, Ecoli,...
%     Glass, Hayes, Image, Iris, PageBlocks,...
%     Seeds, Soybean, Teach, Wine,...
% };
% LabelColumn = [5 7 10 35 9 10 6 20 5 11 8 36 6 1];
% Classes = [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2];
% for i = 1 : 14
%     DataSet = DataSets{i};
%     [Instances, Attributes] = size(DataSet);
%     Classes = length(unique(DataSet(:, LabelColumn(i))));
%     LabMulti(i) = PackDataset(Names{i}, DataSet, LabelColumn(i), Classes, Instances, Attributes-1, '', []);
% end

for i = 1 : 17
    DataSet = UCI(i);
    Data = DataSet.Data;    
    UCI(i).Labels = sort(unique(Data(:, DataSet.LabelColumn)));
end