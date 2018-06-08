function [ urls, bbox ] = process( wnid, start, total )
%PROCESS 此处显示有关此函数的摘要
%   此处显示详细说明

    folder = sprintf('./Images/%s/', wnid);
    if exist(folder, 'dir') == 0
        mkdir(folder);
    end
    
    api = 'http://www.image-net.org/api/';
%     url = [api, 'text/imagenet.sbow.obtain_synset_list'];
%     url = [api, 'download/imagenet.sbow.synset?wnid=%d'];
%% 获取图片链接
    url = [api, 'text/imagenet.synset.geturls?wnid=%s'];
    strs = webread(sprintf(url, wnid), options);
    urls = strsplit(strtrim(strs), '\n')';
    m = size(urls, 1);
    count = min([m, total]);
    for i = start : count
        url = urls{i, 1};
        path = sprintf([folder, wnid, '_%d.jpg'], i);
        if exist(path, 'file') == 0
            download(path, url);
        else
            fprintf('Skip:%s', url);
        end
    end
    
%% 获取区域
%     url = [api, 'download/imagenet.bbox.synset?wnid=%s'];
%     bbox = webread(sprintf(url, wnid), options);
%     save([wnid, '-bbox'], 'bbox');
end