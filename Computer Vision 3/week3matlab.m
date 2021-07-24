corridor = imread('Corridor1.jpg');
grayCorridor = rgb2gray(corridor);
Canny_img = edge(grayCorridor, 'Canny');
[rows, cols] = size(Canny_img);
theta_maximum = 90;
rho_maximum = hypot(rows,cols) - 1;
theta_range = -theta_maximum:theta_maximum-1;
rho_range = -rho_maximum:rho_maximum;

Hough = zeros(length(rho_range), length(theta_range));
for j = 1:rows
    for i = 1:cols
        if Canny_img(j, i) ==1
            x = i - 1;
            y = j - 1;
            for T = theta_range
                R = round((x * cosd(T)) + (y * sind(T)));
                R_Index = R + rho_maximum + 1;
                T_Index = T + theta_maximum + 1;
                Hough(R_Index, T_Index) = Hough(R_Index, T_Index) + 1;
            end
        end
    end
end

[X,Y] = find(Hough>0.47*max(Hough(:)))

imshow(Hough,[],'XData',theta_range,'YData',rho_range,...
            'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

pointsRho = rho_range(X(:));
pointsTheta = theta_range(Y(:));
plot(pointsTheta,pointsRho,'s','color','red');

for k = 1:length(pointsRho)
    for i = 1:1280
        for j = 1:960
            r = pointsRho(k);
            t = pointsTheta(k);
            threshold = abs(i*cosd(t)+j*sind(t)-r);
            if threshold ==0
                allLines(j,i,k) = 1;
            end     
        end
    end
end

aggregatedImage = zeros(size(Canny_img));
for k = 1:length(pointsRho)
    for j = 1:1280
        for i = 1:960
            if allLines(i,j,k) ==1
                aggregatedImage(i,j) = 1;
            end
        end
    end
end

figure,imshow(imfuse(aggregatedImage,corridor))





kitchen1 = imread('kitchen2.jpg');
figure,imshow(kitchen1)
kitchen2 = imread('kitchen1.jpg');
figure,imshow(kitchen2)
graykitchen1 = rgb2gray(kitchen1);
graykitchen2 = rgb2gray(kitchen2);
points1 = detectSURFFeatures(graykitchen1)
points2 = detectSURFFeatures(graykitchen2)

[features1,valid_points1] = extractFeatures(graykitchen1,points1);
[features2,valid_points2] = extractFeatures(graykitchen2,points2);
indexPairs = matchFeatures(features1,features2,'MaxRatio',0.1);

%disp(indexPairs)
matchedPoints1 = valid_points1(indexPairs(:,1),:);
%disp(matchedPoints1)
matchedPoints2 = valid_points2(indexPairs(:,2),:);
%disp(matchedPoints2)
fourPoints1 = transpose(matchedPoints1([1 3 7 14],:).Location)
fourPoints1(3,:) = 1;

average = mean(fourPoints1,2)
d1 = 0;
for i = 1:size(fourPoints1,2)
    cal = sqrt((fourPoints1(1,i)-average(1,1)).^2+(fourPoints1(2,i)-average(2,1)).^2);
    d1 = d1 + cal;
end
T1 = [sqrt(2)/d1 0 -sqrt(2)*average(1,1)/d1;0 sqrt(2)/d1 -sqrt(2)*average(2,1)/d1; 0 0 1]
normalisedFourPoints = zeros(size(fourPoints1))
for i = 1:size(fourPoints1,2)
    temp = fourPoints1(:,i)
    temp = T1*temp
    normalisedFourPoints(:,i) = temp
end

fourPoints2 = transpose(matchedPoints2([1 3 7 14],:).Location)
fourPoints2(3,:) = 1;
average2 = mean(fourPoints2,2)
d2 = 0;
for i = 1:size(fourPoints2,2)
    cal = sqrt((fourPoints2(1,i)-average2(1,1)).^2+(fourPoints1(2,i)-average2(2,1)).^2);
    d2 = d2 + cal;
end
T2 = [sqrt(2)/d2 0 -sqrt(2)*average2(1,1)/d2;0 sqrt(2)/d2 -sqrt(2)*average2(2,1)/d2; 0 0 1]
normalisedFourPoints2 = zeros(size(fourPoints2))
for i = 1:size(fourPoints2,2)
    temp = fourPoints2(:,i)
    temp = T2*temp
    normalisedFourPoints2(:,i) = temp
end

H = calchomography(normalisedFourPoints,normalisedFourPoints2);
H = inv(T2)*H*T1 %Denormalising
disp(H)
save ('mymatrix.mat', 'H');


