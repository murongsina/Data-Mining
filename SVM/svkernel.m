function[k] = svkernel(type, u, v)

    p = 3.86;

    %[m,n]=size(u);
    %fprintf('size u = [%d, %d]\n', m, n);
    %[m,n]=size(v);
    %fprintf('size v = [%d, %d]\n', m, n);
    
    switch type

        case 'linear'
         % Linear Kernal
         % disp('You are using a Linear Kernal')
         k = u*v';

        case 'poly'
         % Polynomial Kernal
         % disp('You are using a Polynomial Kernal')
         k = (u*v' + 1)^p;

        case 'rbf'
         %Radial Basia Function Kernal
         %disp('You are using a RBF Kernal')
         k = exp(-(u-v)*(u-v)'/(2 * p.^2));   

        otherwise

         disp('Please enter a Valid kernel choice ')
         k=0;

    end
return