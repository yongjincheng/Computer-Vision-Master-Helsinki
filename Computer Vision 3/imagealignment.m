
source = im2double(imread('kitchen2.jpg'));
source2 = im2double(imread('kitchen1.jpg'));
newLeft = zeros(size(source));

% The backward warping transformation (rotation + scale about an arbitrary point).
Matrix = load('mymatrix.mat');
M = Matrix.H;
for y = 1:size(newLeft, 1)
    for x = 1:size(newLeft, 2)

        % Transform source pixel location (round to pixel grid).
        p = [x; y; 1];
        q = inv(M) * p;
        u = round(q(1) / q(3));
        v = round(q(2) / q(3));
        
      % Check if target pixel falls inside the image domain.
        if (u > 0 && v > 0 && u <= size(source, 2) && v <= size(source, 1))
            % Sample the target pixel colour from the source pixel.
            newLeft(y, x, :) = source(v, u, :);
        end
    end
end
target = imfuse(source2,newLeft);
%overlay
subplot(141); imshow(source); title('Old Left');
subplot(142); imshow(newLeft); title('New Left');
subplot(143); imshow(source2); title('Right');
subplot(144); imshow(target); title('Stitch');

