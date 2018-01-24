function [ ] = run(X, Y, ker, C, file)
    % 训练模型
    [m, n]=size(X);
    fprintf('size X = [%d, %d]\n', m, n);
    % 训练模型
    [ nsv, alpha, b0 ] = svc( X, Y, ker, C );
    % 输出支持向量个数
    fprintf('svi: %d\n', nsv);
    % 根据alpha计算w
    epsilon = 10e-6;
    svi = alpha(:,1) > epsilon;
    svAlpha = alpha(svi,1);
    svX = X(svi,:);
    svY = Y(svi,:);
    % 构造测试数据集
    x = zeros(961, 2);
    for i = 1:1:30
        for j = 1:1:30
            xi = -3.0 + i*0.2;
            xj = -3.0 + j*0.6;
            xij = zeros(1, 2);
            xij(1, 1:2) = [xi xj];
            x(30 * i + j,:) = xij;
        end
    end
    % 输出x, y的信息
    [m, n] = size(x);
    fprintf('size x = [%d, %d]\n', m, n);
    % 在测试集上测试
    b = repmat(b0, 1, m);
    y = sign(sum(svAlpha.*svY.*kernel(ker, svX, x)) + b);
    [m, n] = size(y);
    fprintf('size y = [%d, %d]\n', m, n);
    % 绘制图形
    h = figure('Visible','off');
    % 绘制测试数据点
    xp = x(y==1,:);
    scatter(xp(:,1), xp(:,2), 1, 'r');
    hold on;
    xn = x(y==-1,:);
    scatter(xn(:,1), xn(:,2), 1, 'b');
    hold on;
    % 绘制正负类点
    XP = X(Y==1,:);
    scatter(XP(:,1), XP(:,2), 12, 'rx');
    hold on;
    XN = X(Y==-1,:);
    scatter(XN(:,1), XN(:,2), 12, 'bo');
    hold on;
    % 绘制支持向量
    scatter(svX(:,1), svX(:,2), 36, 'kO');
    % 绘制坐标轴
    title('SVM');
    xlabel('X');    
    ylabel('Y');
    % 保存图片
    saveas(h, file);
end