function [ Colors ] = AddColor(Colors, RGB)
    [m, ~] = size(Colors);
    Colors(m+1, :) = RGB;
end