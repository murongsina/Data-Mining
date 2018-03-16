function [ Output ] = GridSearch( Clf, X, Y, ValInd, k, P1, P2 )
%GRIDSEARCH 此处显示有关此函数的摘要
% 网格搜索
%   此处显示详细说明
% 参数：
%     Clf   -分类器
%       D   -数据集
%       k   -k折
%  Params   -参数数组
% 输出：
%  Output   -网格搜索、交叉验证结果

    nP1 = length(P1);
    nP2 = length(P2);
    nIndex = 0;
    Output = cell(nP1*nP2, 6);
    for i = 1 : nP1
        for j = 1 : nP2
            nIndex = nIndex + 1;
            % 交叉验证
            [ Accuracy, Precision, Recall, Time ] = CrossValid(Clf, X, Y, ValInd, k);
            % 保存结果
            Output(nIndex, :) = {
                P1(i), P2(j), Accuracy, Precision, Recall, Time
            };
        end
    end
end