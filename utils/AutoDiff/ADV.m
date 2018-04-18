classdef ADV
    
    properties (Access = 'public')
        val;
        dval;
    end
    
    methods
        function [ adv ] = ADV(val, dval)
            if nargin ==0
                adv.val = [];
                adv.dval = [];    
            else
                adv.val = val;
                adv.dval = dval;
            end
        end
        function [ y ] = Add(self, x)
            y = ADV();
            y.val = self.val + x.val;
            y.dval = self.dval + x.dval;
        end
        function [ y ] = Sub(self, x)
            y = ADV();
            y.val = self.val - x.val;
            y.dval = self.dval - x.dval;
        end
        function [ y ] = MatMul(self, x)
            y = ADV();
            y.val = self.val*x.val;
            y.dval = self.dval*x.val + self.val*x.dval;
        end
        function [ y ] = Sin(self)
            y = ADV();
    		y.val = sin(self.val);
        	y.dval = cos(self.val)*self.dval;
        end
        function [ y ] = Cos(self)
            y = ADV();
        	y.val = cos(self.val);
            y.dval = -sin(self.val)*self.dval;
        end
        function [ y ] = Max(self, x)
            y.val = sum(max(self.val, x));
            y.dval = sum(x.dval(y.val > 0,:));
        end
    end
end