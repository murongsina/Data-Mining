function [ im ] = FRAME( h )
%FRAME 此处显示有关此函数的摘要
%   此处显示详细说明
    drawnow();
    frame = getframe(h);
    im = frame2im(frame);
end

