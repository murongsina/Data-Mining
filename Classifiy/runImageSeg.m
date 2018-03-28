images = '../images/';
datasets = '../datasets/artificial/';

imgs = {
    'bull.png', ...
};
I = imread([images, imgs{4}]);
[w, h, d] = size(I);
Ir = reshape(I, w*h, d);
Id = double(Ir)/255;
[ C, V ] = kmeans(Id, 5);
Or = reshape(C, w, h);
O = ones(w, h, d);
for i = 1 : w
    for j = 1 : h        
        O(i, j, :) = Colors(Or(i, j), :);        
    end
end
image(O);
imwrite(O, 'ImageSeg.png');