load('words.mat');

folders = string(ls('./Annotation/n*'));
m = size(folders, 1);
for i = 1 : m
    try
        wnid = folders(i);
        synset = words(strcmp(wnid, words(:,1)),2);
        fprintf('synset: %s\n', synset{1,1});
        folder = sprintf('./Images/%s/', wnid);
        if exist(folder, 'dir')
            list = string(ls(folder));
            if length(list) > 2
                [~,~,~,~,e,~] = regexp(list(end), '\_(\d+)\.');
                str = cell2mat(e{1,1});
                start = str2num(str);
                words{i, 3} = '1';
            else
                words{i, 3} = '0';
                start = 1;
            end
        else
            start = 1;
        end
        fprintf('process %s: %d-%d\n', wnid, start, 40);
        process( wnid, start, 40 );
    catch MException
        fprintf('MException in %s\n', wnid);
    end
end

save words.mat words;