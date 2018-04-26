function [ Accuracy, Time ] = KerSVM(xTrain, yTrain, xTest, yTest, opts)

    C = opts.C;
    kernel = opts.kernel;
    solver = opts.solver;
    [m,~]=size(xTrain);

    tic
    K = Kernel(xTrain, xTrain, kernel);
    Dy = speye(size(K)).*yTrain;
    H = Dy*K*Dy;
    e = ones(m,1);
    Alpha = quadprog(H,-e,[],[],[],[],zeros(m,1),C*e,[],solver);
    svi = Alpha > 0 & Alpha < C;
    Time = toc;
    
    y = sign(Kernel(xTrain, xTest(svi), kernel)*Dy(svi,svi)*Alpha(svi));
    y(y==0)=1;
    
    Accuracy = mean(y==yTest);
end

