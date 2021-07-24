function kernel = myGaussian(std)
    %Gaussian 5x5 with sigma 1 using the formula
    kernel = zeros(5);
    sigma = std;
    temp = 0;
    for i= 1: size(kernel,1)
        for j = 1: size(kernel,2)
            a = (i-3)^2+ (j-3)^2;
            kernel (i,j) = exp(-1*(a)/(2*(sigma^2)));
            temp = temp + kernel(i,j);
        end
    end
    %normalise
    kernel = kernel/temp;
end



