function [  ] = FastTemplate( fw, template, variables )
%FASTTEMPLATE 此处显示有关此函数的摘要
% 快速模板生成
%   此处显示详细说明

    % 写入文件
    fout = fopen(fw, 'a');
    % 处理模板
    [~,~,~,d1,e1,~,~] = regexp(template, '\$(\d+)');
    if ~isempty(e1)
        [m, ~] = size(d1);
        for i = 1 : m
            [~, n] = size(e1{i});
            for j = 1 : n
                index = str2double(char(e1{i}{j}));
                old_ = d1{i}{j}; new_ = variables{index};
                template = replace(template, old_, new_);
                fprintf('replace :%s->%s\n', old_, new_);
            end
        end
    end
    [m, ~] = size(template);
    for i = 1 : m
        fprintf(fout, '%s\r\n', template{i});
    end
    fclose(fout);
end