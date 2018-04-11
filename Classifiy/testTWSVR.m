addpath('.\model\');
addpath('.\data\');

% load('sample sonar');

% xTrain = {X1;X2;X3;X4;X5};
% yTrain = {Y1;Y2;Y3;Y4;Y5};
% 
% xTest = {tstX1;tstX2;tstX3;tstX4;tstX5};
% yTest = {tstY1;tstY2;tstY3;tstY4;tstY5};

[X, Y] = SplitDataLabel(sonarscale, 1);
% 交叉验证
indices = crossvalind('Kfold', Y, 5);
% 分类效果
YY = Y;
YY(YY==-1) = 0;
cp = classperf(YY); % initializes the CP object
% 网格搜索
index = 0;
Output = zeros(1331, 4);
for C1 = 2.^[-5:5]
    for C2 = 2.^[-5:5]
        for p1 = 2.^[-5:5]
            index = index + 1;
            kernel = struct('kernel', 'rbf', 'p1', p1);
            opts = struct('Name', 'KTWSVM', 'C1', C1, 'C2', C2, 'kernel', kernel);
            Acc = zeros(5, 1);
            % 交叉验证
            for i = 1 : 5
                test = (indices == i);
                train = ~test;
                y = KTWSVM(X(train,3),Y(train),X(test,3),opts);
                % updates the CP object with the current classification results
                y(y==0) = 1;
                y(y~=1) = 0;
                classperf(cp, y, test);
            end
            Accuracy = cp.CorrectRate; % queries for the correct classification rate
            Output(index,:) = [C1, C2, p1, Accuracy];
        end
    end
end