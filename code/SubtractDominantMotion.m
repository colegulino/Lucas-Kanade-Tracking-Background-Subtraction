function mask = SubtractDominantMotion(image1, image2)
%% CV Spring 2016 - Cole Gulino
% Find the mask that shows the moving images
% Inputs: 
%   image1:                 Image frame at t
%   image2:                 Image frame at t + 1
% Outputs:
%   mask:                   binary image showing where dynamic objects are
%% Set contents
th = 0.075; % Threshold
%% Find the M that corresponds to the images
image1 = im2double(image1);
image2 = im2double(image2);
M = LucasKanadeAffine(image1,image2);
%% Transform image1 to image2's frame and then get the difference
image1_w = warpH(image1, M, [size(image1,1), size(image1,2)]);
diff_image = image2 - image1_w;
% Erode and dilate image for better results
se = strel('disk', 6);
diff_image = imdilate(diff_image, se);
for angle = 0:5:90
    se = strel('line', 2, angle);
    diff_image = imerode(diff_image, se);
    se = strel('line', 2, -angle);
    diff_image = imerode(diff_image, se);
end
se = strel('disk', 2);
diff_image = imerode(diff_image, se);
mask = diff_image > th;
[rows, cols] = find(mask);
% Keep clusters that are connected and remove those that aren't
mask = bwareaopen(mask, 25);
mask = bwselect(mask, cols, rows, 8);
end
