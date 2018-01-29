function [ Output ] = GridSearch( D, n, C, Sigma )
%GRIDSEARCH 此处显示有关此函数的摘要
% 网格搜索
%   此处显示详细说明
% 参数：
%      D    -数据集
%      n    -n折交叉验证
%      C    -参数C区间
%  Sigma    -参数σ区间

    nC = length(C);
    nS = length(Sigma);
    nIndex = 0;
    Output = zeros(nC*nS, 5);
    for i = 1 : nC
        for j = 1 : nS
            nIndex = nIndex + 1;
            [ Recall, Precision, Accuracy, ~, ~ ] = CrossValid( D, n, C{i}, Sigma{j} );
            Output(nIndex, :) = [ C{i}, Sigma{j}, Recall, Precision, Accuracy ];
        end
    end
end