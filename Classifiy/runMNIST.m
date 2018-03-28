[x, y] = SplitDataLabel(MNIST, 785);
for i = 1 : 10000
    img = reshape(x(i, :), 28, 28);
    Yi = int2str(Y(i));
    yi = int2str(y(i));
    imwrite(img, ['../images/mnist/MNIST-', Yi, '-', yi '.jpg']);
end