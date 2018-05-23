% 构造Dense SIFT特征
% [ discr, class ] = batch_dsift('./Images/', image_net(1:4,1));
save 'dense_sift.mat' 'discr' 'count';
% BOW聚类
load 'dense_sift.mat';
disc = double(discr)';
k = 1000;
[IDX, C] = kmeans(disc, k);
% BoVW数据集
X = bovw(IDX, count, k);