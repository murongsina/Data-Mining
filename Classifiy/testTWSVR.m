addpath('.\model\');
addpath('.\data\');
addpath('.\utils\');

% load('sample sonar');

% xTrain = {X1;X2;X3;X4;X5};
% yTrain = {Y1;Y2;Y3;Y4;Y5};
% 
% xTest = {tstX1;tstX2;tstX3;tstX4;tstX5};
% yTest = {tstY1;tstY2;tstY3;tstY4;tstY5};
load('./data/Sonar.mat');
[X1, Y1] = SplitDataLabel(sonarscale, 1);
X = X1;
% 交叉验证
indices = crossvalind('Kfold', Y1, 5);
% 分类效果
Y = Y1;
Y(Y==-1) = 0;
cp = classperf(Y); % initializes the CP object
% 网格搜索
index = 0;
Output = zeros(343, 4);
for C1 = 2.^[-1:2:11]
    for C2 = 2.^[-1:2:11]
        for p1 = 2.^[-1:2:11]
            index = index + 1;
            fprintf('params:%d\n', index);
            kernel = struct('kernel', 'rbf', 'p1', p1);
            opts = struct('Name', 'KTWSVM', 'C1', C1, 'C2', C2, 'kernel', kernel);
            % 交叉验证
            for i = 1 : 5
                test = (indices == i);
                train = ~test;
                y = KTWSVM(X(train,:),Y1(train,:),X(test,:),opts);
                % updates the CP object with the current classification results
                y(y==0) = 1;
                y(y==-1) = 0;
                classperf(cp, y, test);
            end
            Accuracy = cp.CorrectRate; % queries for the correct classification rate
            Output(index,:) = [C1, C2, p1, Accuracy];
        end
    end
end