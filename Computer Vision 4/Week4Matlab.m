corridor1 = imread('Corridor1.jpg');
corridor2 = imread('Corridor2.jpg');
g1 = rgb2gray(corridor1);
g2 = rgb2gray(corridor2);
canny1 = edge(g1,'canny');
canny2 = edge(g2,'canny');
%imshowpair(canny1,canny2,'montage')
[H1,theta1,rho1] = hough(canny1);
[H2,theta2,rho2] = hough(canny2);
P1 = houghpeaks(H1,5,'threshold',ceil(0.2*max(H1(:))));
P2 = houghpeaks(H2,15,'threshold',ceil(0.2*max(H2(:))));

lines1 = houghlines(canny1,theta1,rho1,P1,'FillGap',5,'MinLength',7);
lines2 = houghlines(canny2,theta2,rho2,P2,'FillGap',5,'MinLength',7);
[rows, columns] = size(canny1);
imshow(corridor1)
hold on
pointsx = []
pointsy = []
votes = []
for i = 1:length(lines2)-1
  for j = i+1:length(lines2)
    xy1 = [lines2(i).point1; lines2(i).point2];
    xy2 = [lines2(j).point1; lines2(j).point2];
    x11 = xy1(1,1);
    y11 = xy1(1,2);
    x12 = xy1(2,1);
    y12 = xy1(2,2);      
    x21 = xy2(1,1);
    y21 = xy2(1,2);
    x22 = xy2(2,1);
    y22 = xy2(2,2);  
    m1 = (y12-y11)/(x12-x11);
    point = linelineintersect([x11 y11; x12 y12; x21 y21; x22 y22]);
    found = false;
    [s1, s2] = size(pointsx);
    for ix=1:s2
        if floor(pointsx(ix)) == floor(point(1)) && floor(pointsy(ix)) == floor(point(2))
            %Straight line passing the same point
            votes(ix) = votes(ix) + 1;
            found = true;
        end
    end
    if found == false
        pointsx(end+1) = point(1);
        pointsy(end+1) = point(2);
        votes(end+1) = 0;
    end
    if abs(floor(point(1))) > size(canny1,1) || abs(floor(point(2))) > size(canny1,2)
        disp(floor(point(1)));
        disp(floor(point(2)));
    end
    %Drawing the line
    xLeft = 1; 
    yLeft = m1 * (xLeft - x11) + y11;
    xRight = 999; 
    yRight = m1 * (xRight - x11) + y11;
    plot([xLeft, xRight], [yLeft, yRight], 'LineWidth',1,'Color','green');  
    %plot(floor(point(1)), floor(point(2)), 'x','LineWidth',2,'Color','red');
  end
end

[s1, s2] = size(votes);
for i=1:s2
   if votes(i) > 0
        plot(floor(pointsx(i)), floor(pointsy(i)), 'x','LineWidth',2,'Color','red');
   end
end


function point = linelineintersect(lines)    
%https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
    x = lines(:,1);
    y = lines(:,2);
    % Calculation
    denominator = (x(1)-x(2))*(y(3)-y(4))-(y(1)-y(2))*(x(3)-x(4));
    point = [((x(1)*y(2)-y(1)*x(2))*(x(3)-x(4))-(x(1)-x(2))*(x(3)*y(4)-y(3)*x(4)))/denominator,((x(1)*y(2)-y(1)*x(2))*(y(3)-y(4))-(y(1)-y(2))*(x(3)*y(4)-y(3)*x(4)))/denominator];
end
