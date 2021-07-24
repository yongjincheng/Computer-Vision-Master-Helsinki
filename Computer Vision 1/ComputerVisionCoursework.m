%Copy and paste each section separately in the command window to see the result
%Running the whole file at once might have the wrong figure 


%Section 1 Reading an image
Image = imread('GOPR1515 06102.jpg');
imshow(Image);
disp(Image(1:5,1:5,:));
%disp(Image(:,:,:)); %<- use this to see all of the matrix information

%whos  %<- To see the information about the image

%Section 2 Grayscale
grayImage = rgb2gray(Image);

%%My implementation
% Splitting
R = 0.2989 *Image(:,:,1);
G = 0.5870 *Image(:,:,2);
B = 0.1140*Image(:,:,3);

figure;
subplot(1,3,1);
imshow(R);
title('Red Channel');

subplot(1,3,2);
imshow(G);
title('Green Channel');

subplot(1,3,3);
imshow(B);
title('Blue Channel');

grayImage2 = R+G+B;
figure;
subplot(1,2,1);
imshow(grayImage)
title('rgb2gray');
subplot(1,2,2);
imshow(grayImage2)
title('my implementation');

% Section 3 Binary
binaryImage = imbinarize(grayImage);
imshow(binaryImage)
disp(binaryImage(1:5,1:5))
%My implementation
binaryImage2 = grayImage;
binaryImage2(grayImage>=100) = 256;
binaryImage2(grayImage<100) = 0;

figure;
subplot(1,2,1);

imshow(binaryImage)
title('imbinarize');
subplot(1,2,2);
imshow(binaryImage2)
title('my implementation');


