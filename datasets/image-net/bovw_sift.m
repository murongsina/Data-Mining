% 特征维度
k = 512;
% 构造Dense SIFT特征
[ discr, count ] = batch_dsift('./Images/', image_net(1:4,1));
% BOW聚类
disc = double(discr)';
[IDX, C] = kmeans(disc, k);
% BoVW数据集
X = bovw(IDX, count, k);