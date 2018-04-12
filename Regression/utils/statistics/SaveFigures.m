function [  ] = SaveFigures( Path, DataSet, LabStat )
%SAVEFIGURES 此处显示有关此函数的摘要
%   此处显示详细说明

    % 保存图表
    Indices = {'MAE', 'RMSE', 'SSE/SST', 'SSR/SSE'};
    for i = 1 : 4
        Index = replace(Indices{i}, '/', '_');
        FileName = [DataSet.Name, '-' Index];
        % bar
        bar(LabStat(:,:,i), 'DisplayName', FileName);
        % save as .fig
        StatPath = [Path, '/fig/', FileName];
        saveas(gcf, StatPath, 'fig');
        fprintf('save: %s\n', StatPath);
        % save as .eps
        StatPath = [Path, '/eps/', FileName];
        saveas(gcf, StatPath, 'epsc');
        fprintf('save: %s\n', StatPath);
    end
end

