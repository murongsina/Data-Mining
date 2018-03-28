cform1 = makecform('cmyk2srgb');
cform2 = makecform('srgb2xyz');

CMYK = 'C([0-9]*)_M([0-9]*)_Y([0-9]*)_K([0-9]*)';
RGB = 'R([0-9]*)_G([0-9]*)_B([0-9]*)';

fd = fopen('Colors.txt');
contents = textscan(fd, '%s');
content = contents{1,1};
fclose(fd);
[m, n] = size(content);
Colors = zeros(0, 3);
for i = 1 : m
    [a1,b1,c1,d1,e1,f1,g1] = regexp(content{i}, CMYK, 'once');
    [a2,b2,c2,d2,e2,f2,g2] = regexp(content{i}, RGB, 'once');
    if ~isempty(e1)
        fprintf('Find CMYK:%s\n', d1);
        cmyk = str2double(e1);
        Color = applycform(cmyk, cform1);
        [ Colors ] = AddColor(Colors, Color);
    end
    if ~isempty(e2)
        fprintf('Find RGB:%s\n', d2);
        rgb = str2double(e2);
        Color = applycform(rgb, cform2);
        [ Colors ] = AddColor(Colors, Color);
    end
end