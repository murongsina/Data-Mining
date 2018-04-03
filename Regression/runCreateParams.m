addpath(genpath('./utils'));

% 核函数参数
RangeP1 = 2.^(1:2:10)';
kernel = struct('kernel', 'rbf', 'p1', RangeP1);
% 分类器网格搜索参数
C = 2.^(0:2:10)';
C1 = 2.^(0:2:10)';
C2 = 2.^(0:2:10)';
C3 = 2.^(0:2:6)';
C4 = 2.^(0:2:6)';
EPS1 = 2.^(0:2:6)';
EPS2 = 2.^(0:2:6)';
RHO = 2.^(-2:2:8)';
LAMBDA = 2.^(-2:2:8)';
Params0 = struct('Name', 'TWSVR', 'C1', C1, 'C2', C2, 'C3', C3, 'C4', C4, 'eps1', EPS1, 'eps2', EPS2, 'Kernel', kernel);
Params1 = struct('Name', 'TWSVR_Xu', 'C1', C1, 'C2', C2, 'eps1', EPS1, 'eps2', EPS2, 'Kernel', kernel);
Params2 = struct('Name', 'MTL_TWSVR', 'C1', C1, 'C2', C2, 'eps1', EPS1, 'eps2', EPS2, 'Kernel', kernel);
Params3 = struct('Name', 'MTL_TWSVR_Xu', 'C1', C1, 'C2', C2, 'eps1', EPS1, 'eps2', EPS2, 'Kernel', kernel);
Params4 = struct('Name', 'MTL_TWSVR_Mei', 'C1', C1, 'C2', C2, 'eps1', EPS1, 'eps2', EPS2, 'rho', RHO, 'lambda', LAMBDA, 'Kernel', kernel);
% % 转换参数表
% OParams = {Params0;Params1;Params2;Params3;Params4};
% nParams = length(OParams);
% for i = 1 : nParams
%     % 初始化参数表
%     fprintf('Params\n')
%     IParams{i, 1} = CreateParams(OParams{i});
% end
Params = [];
kernel = struct('kernel', 'rbf');
opts.Name = 'TWSVR';
for i = C1'
    opts.C1 = i;
    for j = C2'
        opts.C2 = j;
        for k = C3'
            opts.C3 = k;
            for l = C4'
                opts.C4 = l;
                for m = EPS1'
                    opts.eps1 = m;
                    for n = EPS2'
                        opts.eps2 = n;
                        for o = RangeP1'
                            kernel.p1 = o;
                            opts.Kernel = kernel;
                            Params = cat(1, Params, opts);
                        end
                    end
                end
            end
        end
    end
end
% 保存参数表
% save('LabIParams.mat', 'IParams');