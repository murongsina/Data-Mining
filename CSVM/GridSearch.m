function [ Output ] = GridSearch( Clf, X, Y, ValInd, k, Params )
%GRIDSEARCH 此处显示有关此函数的摘要
% 网格搜索
%   此处显示详细说明
% 参数：
%      Clf    -分类器
%        D    -数据集
%   ValInd    -交叉验证索引
%        K    -K折
%   Params    -参数网格
% 输出：
%   Output    -网格搜索、交叉验证结果

    nP = length(Params);
    Outputs = cell(nP, 6);
    for i = 1 : nP
        % 设置参数
        Clf = Clf.SetParams(Params(i));
        % 交叉验证
        [ Accuracy, Precision, Recall, Time ] = CrossValid(Clf, X, Y, ValInd, k);
        % 保存结果
        Output = Clf.GetParams();
        Output.Accuracy = Accuracy;
        Output.Precision = Precision;
        Output.Recall = Recall;
        Output.Time = Time;
        Outputs(i, :) = Output;
    end
end