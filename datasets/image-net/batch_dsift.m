function [ discr, count ] = batch_dsift( folder, wnids )
%BATCH_DSIFT 此处显示有关此函数的摘要
% Batch Dense SIFT
%   此处显示详细说明
   
    discr = []; % Dense SIFT描述符
    count = []; % Dense SIFT特征统计
    for ci = 1 : size(wnids, 1)
        files = ls(fullfile(folder, wnids{ci}, '*.jpg'));
        for fi = 1 : size(files, 1)
            try
                file = fullfile(folder, wnids{ci}, files(fi,:));
                fprintf('image_dsift:%s\n', files(fi,:));
                I = imread(file);
                [~, d] = image_dsift(I);
                [~, n] = size(d);
                
%                 clf
%                 imshow(I);
%                 hold on;
%                 plot_sift( f, d );

                discr = cat(2, discr, d);
                count = cat(1, count, n);
            catch MException
                fprintf('MException in:%s\n', files(fi,:));
            end
        end
    end
end