Task = [];
ValInd = [];
for i = 1 : 139
    L = i*ones(size(Y{i}));
    Task = cat(1, Task, L);
    V = crossvalind('Kfold', L, 5);
    ValInd = cat(1, ValInd, V);
end
XX = cell2mat(X');
YY = cell2mat(Y');