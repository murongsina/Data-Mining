function [ IParams ] = PrintParams( Path, IParams )
%PRINTPARAMS 此处显示有关此函数的摘要
% 输出参数表信息
%   此处显示详细说明

    % 对参数表排序
    n = length(IParams);
    nParams = zeros(n, 1);
    for i = 1 : n
        nParams(i, 1) = GetParamsCount(IParams{i});
    end
    [nParams, IDX] = sort(nParams);
    IParams = IParams(IDX);
    % 测试获取参数的时间
    fd = fopen(Path, 'w');
    for i = 1 : n
        Method = IParams{i};
        tic
        GetParams(Method, 1);
        Time = toc;
        fprintf(fd, '%s:%d params %.2fs.\n', Method.Name, nParams(i, 1), nParams(i, 1)*Time);
    end
    fclose(fd);
end