function result = myfilter_replicate(image,kernel)
originalImage = image;

%Padding function

% Trying to figure things out here 
%k = 5; image = 256 ; padd = 260 ;  centrepad = 260 - 256 / 2 = 2;
% copy from 3 to 258; ( two zero layer)
% 3 = 1+ centrepad;
%258 = padd - centrepad
%k = 3; image = 256 ; padd = 258 ; centrepad = 258 - 256 / 2 = 1;
%so copy image =from 2 to 257; ( one zero layer)
% 2 = 1 + centrepad;
paddedImage = zeros(size(image)+size(kernel)-1);
centrePadY = (size(paddedImage,1)-size(image,1))/2;
centrePadX = (size(paddedImage,2)-size(image,1))/2;

%copy original image to padded image
for a = 1+centrePadY:size(paddedImage,1)-centrePadY
    for b = 1+centrePadX:size(paddedImage,2)-centrePadX
        paddedImage (a,b) = image (a-centrePadY,b-centrePadX);
    end
end

%padding function
for c = 1: size(paddedImage,1)
    for d = 1: size (paddedImage,2)
        %top
        if c < centrePadY+1 
            paddedImage(c,d) = paddedImage(centrePadY+1,d);
        end
        

    end
end
for c = 1: size(paddedImage,1)
    for d = 1: size (paddedImage,2)
        %left
        if d< centrePadX+1
            paddedImage(c,d) = paddedImage(c,centrePadX+1);
        end

    end
end
for c = 1: size(paddedImage,1)
    for d = 1: size(paddedImage,2)
        %bottom
        if c >size(paddedImage,1)-centrePadY
            paddedImage(c,d) = paddedImage(size(paddedImage,1)-centrePadY,d);
        end
    end
end
for c = 1: size(paddedImage,1)
    for d = 1: size(paddedImage,2)
        %right
        if d >size(paddedImage,2)-centrePadX
            paddedImage(c,d) = paddedImage(c,size(paddedImage,2)-centrePadX);
        end
    end
end
%End of padding Function

%Convolution
moveY = size(paddedImage,1)-size(kernel,1)+1; 
moveX = size(paddedImage,2)-size(kernel,2)+1;
for c = 1: moveY
    for d = 1: moveX
        accumulator = 0;
        tempImage = paddedImage(c:c+size(kernel,1)-1,d:d+size(kernel,2)-1);
        accumulator = accumulator + sum(sum(tempImage.*kernel));
        %accumulator =accumulator + sum(tempImage.*kernel ,'all');
        if c <= size(originalImage,1) && d <= size(originalImage,2)
        originalImage (c,d) = accumulator;
        end
    end
end
result = originalImage;
end