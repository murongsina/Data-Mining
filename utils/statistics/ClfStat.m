function [ Stat ] = ClfStat(y, yTest)
%CLFSTAT 此处显示有关此函数的摘要
%   此处显示详细说明

    TP = sum(yTest(y==1)==1);
    FP = sum(yTest(y==1)==-1);
    FN = sum(yTest(y==-1)==1);
    TN = sum(yTest(y==-1)==-1);

    Precision = TP/(TP+FP);
    Recall = TP/(TP+FN);
    F1 = 2*Precision*Recall/(Precision+Recall);
    Accuracy = (TP+TN)/(TP+TN+FP+FN);
    Stat = [ Accuracy, Precision, Recall, F1 ];
end