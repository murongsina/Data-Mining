datasets = ['../datasets/hcc-survival/hcc-description', '.names'];

fd = fopen(datasets, 'r');
contents = textscan(fd, '%s');
content = contents{1,1};
fclose(fd);

types = {'continuous', 'integer', 'nominal', 'ordinal'};
Types = [1 2 3 2];
tag = 'Attribute';
[m, ~] = size(content);
AttributeTypes = zeros(1, 50);
nIndex = 0;
start = false;
for i = 1 : m
    if start == false
        if strcmp(content{i}, tag)
            start = true;
        end
    else
        for j = 1 : 4
            if strcmp(types{j}, content{i})
                nIndex = nIndex + 1;
                AttributeTypes(1, nIndex) = Types(j);
            end
        end
    end
end

size(AttributeTypes)
% AttributeTypes