Params = Params4;
n = Classifier.CountParams(Params);
for index = 1 : n
    params(index) = Classifier.CreateParams(Params, index);
    fprintf('\n');
end