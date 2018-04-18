function [x,y,precision,t] = TSVM(X,Y,tstX,tstY,C1,C2)

    tic

    [~,n1] = size(X);

    v1 = find(Y > 0);
    v2 = find(Y < 0);

    A = X(v1,:);
    B = X(v2,:);

    H1 = [];
    H2 = [];
    a = length(v1);
    b = length(v2);
    e1 = ones(a,1);
    e2 = ones(b,1);
    R = [A e1];
    S = [B e2];
    lb1 = zeros(b,1);
    ub1 = C1*ones(b,1);
    lb2 = zeros(a,1);
    ub2 = C2*ones(a,1);
    f1 = -ones(a,1);
    f2 = -ones(b,1);

    IH1 = pinv(R'*R);
    H1 = S*IH1*S';
    [alpha, ~] = quadprog(H1,f2,[],[],[],[],lb1,ub1);
    x = alpha;

    IH2 = pinv(S'*S);
    H2 = R*IH2*R';
    [beta, ~] = quadprog(H2,f1,[],[],[],[],lb2,ub2);
    y = beta;

    u = -IH1*S'*x;
    v = -IH2*R'*y; 

    w1 = u(1:n1,:);
    b1 = u(end);

    w2 = v(1:n1,:);
    b2 = v(end);

    [d1, d2] = size(tstX);

    for k = 1:d1
    C1(1,k) = abs(tstX(k,:)*w1+b1);
    end
    for k = 1:d1
    C2(1,k) = abs(tstX(k,:)*w2+b2);
    end

    Z=sign(C2-C1);
    Z(Z==0) = 1;

    err = sum(Z' ~= tstY);
    err = err/length(tstY);
    precision = 1-err;

    toc
    t = toc;
end
