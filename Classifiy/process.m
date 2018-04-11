fd = fopen('./data/sonar_scale');
contents = textscan(fd, '%s');
content = contents{1,1};
fclose(fd);
[m, n] = size(content);
for j = 1 : m
    for i = 1 : 60
        [a1,b1,c1,d1,e1,f1,g1] = regexp(content{j}, [int2str(i), ':'], 'once');
        if ~isempty(e1)
            fprintf('Find :%s\n', d1);
            content{j} = replace(content{j}, d1, '');
        end
    end
end