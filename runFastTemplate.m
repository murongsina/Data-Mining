fw = './templates/figures.txt';

old = '';
subsection = 0;
list = dir('./eps/');
m = length(list);
for i = 1 : m
    item = list(i);
    if item.isdir == 0
        name = item.name;
        idx = regexp(name, '.eps');
        if idx > 0
            % fig
            var1 = name;
            % 提取数据集名称和指标名
            name = replace(name, '.eps', '');
            names = split(name, '-');
            name1 = names{1};
            % caption
            name2 = replace(names{2}, '_', '/');
            var2 = [name2, ' of ' name1];
            % label
            name2 = names{2};
            var3 = [name2, '_', name1];
            % 新的章节
            if strcmp(old, name1) == 0
                % 分页
                if subsection > 1
                    FastTemplate( fw, pagebreak, {} );
                end
                % 段落
                subsection = subsection + 1;
                FastTemplate( fw, paragraph, {name1} );
            end
            % 图表
            FastTemplate( fw, figure, {var1, var2, var3} );
            old = name1;
        end
    end
end