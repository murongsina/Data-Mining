PI = 3.1415926;

x = { ADV(PI, 1); ADV(2, 0); ADV(1, 0) };

y1 = x{1}.Cos();
y2 = x{1}.Sin();
y3 = x{2}.MatMul(y1);
y4 = x{3}.MatMul(y2);
y5 = x{2}.MatMul(y2);
y6 = x{3}.MatMul(y1);

z1 = y3.Add(y4);
z2 = y6.Sub(y5);

% E = ADV([1 1 1]', [0 0 0]');
% X = ADV([1 2;3 4;5 6], [0 0;0 0;0 0]);
% w = ADV([0 0]', [0 0]');
% y = ADV([1 1 1]', [0 0 0]');
% 
% A = X.MatMul(w);
% output = E.Sub(A.MatMul(y));
% loss = output.Max(0);
