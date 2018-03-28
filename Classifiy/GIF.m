function [  ] = GIF( im, file )
%GIT 此处显示有关此函数的摘要
%   此处显示详细说明
    [nImages, ~] = size(im);
    for idx = 1 : nImages
        [A,map] = rgb2ind(im{idx},256);
        if idx < 3
            imwrite(A,map,file,'gif','LoopCount',Inf,'DelayTime',1);
        else
            imwrite(A,map,file,'gif','WriteMode','append','DelayTime',0.3);
        end
    end
end

