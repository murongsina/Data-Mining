function [ image_net ] = add( image_net, wnid, disc )
%ADD 此处显示有关此函数的摘要
%   此处显示详细说明

    if isempty(find(strcmp(image_net(:,1), wnid), 1))
        [m, ~] = size(image_net);
        image_net(m + 1, :) = { wnid, disc };
    end
end