addpath('.\model\');
addpath('.\data\');

load('sample sonar');

xTrain = {X1;X2;X3;X4;X5};
yTrain = {Y1;Y2;Y3;Y4;Y5};

xTest = {tstX1;tstX2;tstX3;tstX4;tstX5};
yTest = {tstY1;tstY2;tstY3;tstY4;tstY5};

index = 0;
Output = zeros(121, 3);
for C = 2.^[-5:5]
    for p1 = 2.^[-5:5]
        index = index + 1;
        kernel = struct('kernel', 'rbf', 'p1', p1);
        opts = struct('Name', 'KTWSVM', 'C1', C, 'C2', C, 'kernel', kernel);
        Acc = zeros(5, 1);
        for i = 1 : 5
            y = KTWSVM(xTrain{i}, yTrain{i}, xTest{i}, opts);
            Acc(i) = mean(yTest{i}==y);
        end
        Accuracy = mean(Acc);
        Output(index,:) = [C, p1, Accuracy];
    end
end