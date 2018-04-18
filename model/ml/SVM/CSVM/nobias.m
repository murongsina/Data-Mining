function [ nb ] = nobias( ker )
% nobias 此处显示有关此函数的摘要
% nobias returns true if SVM kernel has no implicit bias
%
%  Usage: nb = nobias(ker)
%
%  Parameters: ker - kernel type
%              
%   此处显示详细说明
    if (nargin ~= 1)
        help nobias
    else
        switch lower(ker)
            case {'linear', 'rbf'}
                nb = 1;
            otherwise
                nb = 0;
        end
    end
end

