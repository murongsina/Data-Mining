function [ Accuracy, Time ] = KerSVM(xTrain, yTrain, xTest, yTest, opts)

    C = opts.C;
    kernel = opts.kernel;
    solver = opts.solver;
    [m,~]=size(xTrain);

    tic
    H = diag(yTrain)*Kernel(xTrain, xTrain, kernel)*diag(yTrain);
    e = ones(m,1);
    Alpha = quadprog(H,-e,[],[],[],[],zeros(m,1),C*e,[],solver);
    svi = Alpha > 0 & Alpha < C;
    Time = toc;
    
    y = sign(Kernel(xTrain, xTest(svi), kernel)*diag(yTrain(svi))*Alpha(svi));
    y(y==0)=1;
    
    Accuracy = mean(y==yTest);
end

