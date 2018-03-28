classdef BP
    %BP 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        Name;
        learn;
        w1,w2,w3,w4;
        b1,b2,b3,b4;
    end
    
    methods
        function [ clf ] = BP()
            clf.Name = 'BackProp';
            clf.learn = 0.2;

            clf.w1 = rand(2, 3);
            clf.w2 = rand(3, 4);
            clf.w3 = rand(4, 5);
            clf.w4 = rand(5, 1);

            clf.b1 = rand(1, 3);
            clf.b2 = rand(1, 4);
            clf.b3 = rand(1, 5);
            clf.b4 = rand(1, 1);
        end
        function [ clf, Time ] = Fit(clf, xTrain, yTrain)
            tic;
            for i = 1 : 2000
                % forward
                h0 = xTrain;
                h1 = h0*clf.w1 + clf.b1;
                h2 = h1*clf.w2 + clf.b2;
                h3 = h2*clf.w3 + clf.b3;
                h4 = h3*clf.w4 + clf.b4;
                % finish
                if max(abs(yTrain - h4)) < 0.001
                    break;
                end
                % backprop
                delta4 = (yTrain - h4).*((1-h4).*h4);
                delta3 = clf.w3*delta4.*((1-h3).*h3);
                delta2 = clf.w2*delta3.*((1-h2).*h2);
                delta1 = clf.w1*delta2.*((1-h1).*h1);
                % update
                clf.w4 = clf.w4 + clf.learn*delta4*h4;
                clf.w3 = clf.w3 + clf.learn*delta3*h3;
                clf.w2 = clf.w2 + clf.learn*delta2*h2;
                clf.w1 = clf.w1 + clf.learn*delta1*h1;
            end
            Time = toc;
        end
        function [ yTest ] = Predict(clf, yTest)
            % forward
            h0 = yTest;
            h1 = h0*clf.w1 + clf.b1;
            h2 = h1*clf.w2 + clf.b2;
            h3 = h2*clf.w3 + clf.b3;
            h4 = h3*clf.w4 + clf.b4;
            yTest = h4;
        end
        function disp(clf)
            fprintf('%s: learn=%4.5f\n', clf.learn);
        end
    end
    
end

