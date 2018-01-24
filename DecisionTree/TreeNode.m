classdef tree_node
    %TREE_NODE 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        split_index % 分割轴
        split_value % 分割值
        child_left  % 左子节点
        child_right % 右子节点
    end
    
    properties (Constant)
        epsilon = 10e-6;
    end
    
    methods
        function obj = tree_node( idx, val, left, right )
            obj.split_index = idx;
            obj.split_value = val;
            obj.child_left = left;
            obj.child_right = right;
        end        
    end
    
    methods(Access = 'private') % Access by class members only
    end
    
end

