function [  ] = plot_bbox( wnid, id )
%PLOT_BBOX 此处显示有关此函数的摘要
%   此处显示详细说明

    % 绘制图片
    folder = sprintf('./Images/%s/', wnid);
    file = sprintf([folder, wnid, '_%04d.jpg'], id);
    try
        im = imread(file);
        imshow(im);
    catch MException
        fprintf('No such file:%s\n', file);
    end
    % 绘制坐标
    box = bbox(wnid, id);
    rectangle('position', [box(1), box(2), box(3)-box(1), box(4)-box(2)]);    
end