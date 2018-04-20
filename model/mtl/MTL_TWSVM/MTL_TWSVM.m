function [ W, funcVal ] = MTL_TWSVM( X, Y, opts )
%MTL_TWSVC 此处显示有关此函数的摘要
%   此处显示详细说明

    if isfield(opts, 'rho_L2')
        rho_L2 = opts.rho_L2;
    else
        rho_L2 = 0;
    end
    
    X = multi_transpose(X);

    [ W, funcVal ] = Least_Lasso( X, Y, @GradEval, @FuncEval, @L1Proximal, opts );
    
    function [ z, l1_comp_val ] = L1Proximal(v, beta)
%   function [z, l1_comp_val] = l1_projection (v, beta)
        % 计算Soft-threshold投影
        % 计算投影后L1范数
        % this projection calculates
        % argmin_z = \|z-v\|_2^2 + beta \|z\|_1
        % z: solution
        % l1_comp_val: value of l1 component (\|z\|_1)
        z = sign(v).*max(0,abs(v)- beta/2);
        
        l1_comp_val = sum(sum(abs(z)));
%   end
    end

    function [ funcVal ] = FuncEval(X, Y, W)
        funcVal = 0;
        for i = 1: task_num
            funcVal = funcVal + 0.5 * norm (Y{i} - X{i}' * W(:, i), 'fro')^2;
        end
        funcVal = funcVal + rho_L2 * norm(W, 'fro')^2;
    end

    function [ grad_W ] = GradEval(X, Y, W)
        grad_W = [];
        for t_ii = 1:task_num
            XWi = X{t_ii}' * W(:,t_ii);
            XTXWi = X{t_ii}* XWi;
            grad_W = cat(2, grad_W, XTXWi - XY{t_ii});
        end
        grad_W = grad_W + rho_L2 * 2 * W;
    end

end

