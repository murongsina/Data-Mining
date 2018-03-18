classdef Classifier
    %CLASSIFIER 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        
    end
    
    methods (Static)
        function [ clf ] = CreateClf(params)
            switch(params.Name)
                case {'CSVM'}
                    clf = CSVM(params);
                case {'TWSVM'}
                    clf = TWSVM(params);
                case {'KTWSVM'}
                    clf = KTWSVM(params);
                case {'LSTWSVM'}
                    clf = LSTWSVM(params);
                case {'KNNSTWSVM'}
                    clf = KNNSTWSVM(params);
                otherwise                    
                    throw(MException('Classifier', '未知分类器！'));
            end                    
        end
        function [ Count ] = GetPropertyCount(root)
            % 得到叶节点数目
            Count = 0;
            if isstruct(root)
                names = fieldnames(root);
                [m, ~] = size(names);
                for i = 1 : m
                    SubParamTree = root.(names{i});
                    Count = Count + Classifier.GetPropertyCount(SubParamTree);
                end
            else
                Count = 1;
            end
        end
        function [ Count ] = GetParamsCount(root)
            % 获取所有参数的组合数
            Count = 1;
            if isstruct(root)
                names = fieldnames(root);
                [m, ~] = size(names);
                for i = 1 : m
                    child = root.(names{i});
                    x = Classifier.GetParamsCount(child);
                    Count = Count * x;
                end
            else
                [m, ~] = size(root);
                Count = Count * m;
            end
        end
        function [ Params ] = GetParams(root, index)
            names = fieldnames(root);
            [m, ~] = size(names);
            % 分解下标
            for i = 1 : m
                name = names{i};
                child = root.(name);
                wi = Classifier.GetParamsCount(child);
                % 取得当前位的idx、得到高位num
                idx = mod(index-1, wi)+1;
                index = ceil(index / wi);
                % 访问子节点
                if isstruct(child)
                    Params.(name) = Classifier.GetParams(child, idx);
                else
                    Params.(name) = child(idx, :);
                end
            end
        end
        function [ Params ] = CreateParams(root)
            nParams = Classifier.GetParamsCount(root);
            for index = 1 : nParams
                Params(index) = Classifier.GetParams(root, index);
            end
        end        
    end
    
end