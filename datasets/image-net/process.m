function [ strs, bbox ] = process( wnid )
%PROCESS 此处显示有关此函数的摘要
%   此处显示详细说明

    options = weboptions('Timeout', 300);
    api = 'http://www.image-net.org/api/';
%     url = [api, 'text/imagenet.sbow.obtain_synset_list'];
%     url = [api, 'download/imagenet.sbow.synset?wnid=%d'];
    % 获取图片链接
    url = [api, 'text/imagenet.synset.geturls?wnid=%s'];
    strs = webread(sprintf(url, wnid), options);
    save([wnid, '-urls'], 'strs');
    % 获取区域
    url = [api, 'download/imagenet.bbox.synset?wnid=%s'];
    bbox = webread(sprintf(url, wnid), options);
    save([wnid, '-bbox'], 'bbox');
end