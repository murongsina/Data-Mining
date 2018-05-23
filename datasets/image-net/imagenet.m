load('image_net.mat');

[m, n] = size(image_net);
for i = 1 : m
    try
        wnid = image_net{i, 1};
        folder = sprintf('./Images/%s/', wnid);
        if exist(folder, 'dir')
            list = dir(folder);
            if length(list) > 2
                [~,~,~,~,e,~] = regexp(list(end).name, '\_0+(\d+)\.');
                str = cell2mat(e{1,1});
                start = str2num(str);
                image_net{i, 3} = true;
            else
                start = 1;
            end
        else
            start = 1;
        end
        fprintf('process in %s\n', wnid);
        [ strs, bbox ] = process( wnid );
        fprintf('prepare in %s-%d\n', wnid, start);
        prepare( wnid, strs, start, 40 );
    catch MException
        fprintf('MException in %s\n', wnid);
    end
end

save image_net.mat image_net;