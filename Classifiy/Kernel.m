function [ Y ] = Kernel(U, V, opts)
%KERNEL 此处显示有关此类的摘要
% 核函数
%   此处显示详细说明
% 参数：
%     U    -矩阵U
%     V    -矩阵V
%  opts    -核函数参数

    names = fieldnames(opts);
    [m, ~] = size(names);
    for i = 1 : m
        name = names{i};
        switch(name)
            case {'kernel'}
                % 核函数名称
                kernel = opts.kernel;
            case {'p1'}
                % 参数1
                p1 = opts.p1;
            case {'p2'}
                % 参数2
                p2 = opts.p2;
            case {'p3'}
                % 参数3
                p3 = opts.p3;
        end
    end

    switch kernel
        case 'linear'
            % Linear Kernel
            % disp('You are using a Linear Kernal')
            Y = U*V.';
        case 'poly'
            % Polynomial Kernel
            % disp('You are using a Polynomial Kernal')
            Y = (p1*U*V'+p2).^p3;
        case 'rbf'
            % Gaussian Kernel
            % disp('You are using a RBF Kernal')
            D = XYDist(U, V);
            Y = exp(-D.^2/(2*p1.^2));
        case 'sigmoid'
            % Sigmoid Kernel
            Y = tanh(p1*U*V'+p2);
        case 'log'
            % Log Kernel
            D = XYDist(U, V);
            Y = -log(1+D.^p1);
        case 'none'
            % None Kernel
            Y = U;
        otherwise
            disp('Please enter a Valid kernel choice ')
            Y = [ ];
    end 
end