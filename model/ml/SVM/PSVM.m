function  [ yTest, Time ] = PSVM( xTrain, yTrain, xTest, opts )
%PSVM 此处显示有关此函数的摘要
% Proximal Support Vector Machine
%   此处显示详细说明

%% Parse opts
nu = opts.nu;
kernel = opts.kernel;

%% Fit
tic;
X = xTrain;
Y = yTrain;
A = Kernel(X, X, kernel);
e = ones(size(Y));
H = A*A' + 1;
I = speye(size(H));
D = I.*Y;
Alpha = Cond(D*H*D + 1/nu*I)\e;

%% Get w,b
DAlpha = D*Alpha;
w = A'*DAlpha;
b = sum(DAlpha);
Time = toc;

%% Predict
yTest = sign(Kernel(xTest, X, kernel) * w + b);
yTest(yTest==0) = 1;

end

