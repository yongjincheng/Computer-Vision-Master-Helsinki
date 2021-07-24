%Section 2.11

brickwall = im2double(imread('brick_wall.tiff'));
%imshow(brickwall)
kernel = boxfilter(3);
%Try kernel of different size
%kernel = boxfilter(13);
%kernel = boxfilter(23);
%kernel = boxfilter(33);
filtered_brickwall= myfilter_replicate(brickwall,kernel);
imshow(filtered_brickwall)

%Section 2.12
imshow(brickwall)
title('original')
kernel = myGaussian(1)
%kernel = myGaussian(3)
%kernel = myGaussian(5)
filtered_brickwall= myfilter_replicate(brickwall,kernel);
figure,imshow(filtered_brickwall)
title('Filtered')




%Section 2.21
image = imread('GOPR1515 03850.jpg');
grayImage = rgb2gray(image);

points = detectSURFFeatures(grayImage)

image2 = imread('GOPR1515 03852.jpg');
grayImage2= rgb2gray(image2);
points2 = detectSURFFeatures(grayImage2)

[feature1, validPoints1] = extractFeatures(grayImage, points);
[feature2, validPoints2] = extractFeatures(grayImage2, points2);

figure,imshow(image); hold on;
plot(validPoints1.selectStrongest(20));
figure,imshow(image2); hold on;
plot(validPoints2.selectStrongest(20));

%Section2.22
threshold = 1.0;   

for i = 1:size(feature1,1)
    euclid = zeros(size(feature2,1));
    for j=1:size(feature2,1)
           euclid(j) = sqrt(sum((feature1(i,:)-feature2(j,:)).^2));
    end

    [vals,indx] = sort(euclid);        
    if (vals(1) < threshold * vals(2))
      match(i) = indx(1);
    else
      match(i) = 0;
    end
end
for i = 1:size(match,2)
    if match(1,i)== 0
        continue
    else
        myindexpairs(i,1)=i
        myindexpairs(i,2)=match(1,i)
    end
end
myindexpairs( all(~myindexpairs,2), : ) = []; %Remove the row
matchedPoints1 = validPoints1(myindexpairs(:,1),:);
matchedPoints2 = validPoints2(myindexpairs(:,2),:);
figure; showMatchedFeatures(image,image2,matchedPoints1,matchedPoints2);

%Matlab
indexPairs = matchFeatures(feature1,feature2);
matchedPoints1 = validPoints1(indexPairs(:,1),:);
matchedPoints2 = validPoints2(indexPairs(:,2),:);
figure; showMatchedFeatures(image,image2,matchedPoints1,matchedPoints2);





%Section 2.31
image = double(imread('son3.gif'));
%image = imrotate(image,30)
%image = imrotate(image,60)
%image = imrotate(image,90)
image = imrotate(image,120)
figure,imshow(image)
title('original')
[X, Y] = size(image);
disp(X)
disp(Y)
imgX = zeros(X, X);
imgY = zeros(Y, Y);
for u = 0 : (X - 1)
    for x = 0 : (X - 1)
        imgX(u+1, x+1) = exp(-2 * pi * 1i / X * x * u);
    end    
end
for v = 0 : (Y - 1)
    for y = 0 : (Y - 1)
        imgY(y+1, v+1) = exp(-2 * pi * 1i / Y * y * v);
    end    
end
F = imgX * double(image) * imgY;
figure,imshow(F)
title('Fourier Image')

%2.32Log magnitude and threshold image
F = fftshift(F); 
F = abs(F); % Get the magnitude
F = log(F + 1); 
figure, imshow(F*255,[]) 
disp(F)
title('Log Magnitude')
threshold = 8.0
F(abs(F)<threshold) = 0;
figure,imshow(F*255,[])
title('Threshold')





        
    




