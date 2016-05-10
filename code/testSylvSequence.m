%% CV Spring 2016 - Cole Gulino
% testCarSequence.m
% Description: Run the script to track the toy from each image frame in the video
clear;
%% Load the video frames and the bases
load(fullfile('..','data','sylvseq.mat'));
load(fullfile('..','data','sylvbases.mat'));
%% Get the constants and preallocate values
no_frames = size(frames,3);
rects = zeros(no_frames, 4);
rects_old = rects;
rects(1,:) = [102, 62, 156, 108];
rects_old(1,:) = [102,62,156,108];
rect_show = [rects(1,1), rects(1,2), ...
        abs(rects(1,1)-rects(1,3)), abs(rects(1,2)-rects(1,4))];
yellow = uint8([255 255 0]);
shapeInserter = vision.ShapeInserter('BorderColor', 'Custom', 'CustomBorderColor', yellow);
RGB = repmat(frames(:,:,1), [1,1,3]);
J = step(shapeInserter, RGB, uint32(rect_show));
figure;
imshow(J);
%% Get the rectangles of the frame
for i = 2:no_frames
    % Get the images
    It = im2double(frames(:,:,i-1));
    It1 = im2double(frames(:,:,i));
    % Run Lucas Kanade
    [u, v] = LucasKanadeBasis(It, It1, rects(i-1,:), bases);
    [u1, v1] = LucasKanade(It, It1, rects(i-1,:));
    % Update rects with the new rectangle
    rects(i,1) = rects(i-1,1) + u;
    rects(i,2) = rects(i-1,2) + v;
    rects(i,3) = rects(i-1,3) + u;
    rects(i,4) = rects(i-1,4) + v;
    rects_old(i,1) = rects_old(i-1,1) + u;
    rects_old(i,2) = rects_old(i-1,2) + v;
    rects_old(i,3) = rects_old(i-1,3) + u;
    rects_old(i,4) = rects_old(i-1,4) + v;
    % Get a rectangle for showing on video
    rect_show = [rects(i,1), rects(i,2), ...
        abs(rects(i,1)-rects(i,3)), abs(rects(i,2)-rects(i,4))];
    rect_old_show = [rects_old(i,1), rects_old(i,2), ...
        abs(rects_old(i,1)-rects_old(i,3)), abs(rects_old(i,2)-rects_old(i,4))];
    % Display the image
    RGB = repmat(frames(:,:,i), [1,1,3]);
    RGB = insertShape(RGB, 'Rectangle', uint32(rect_show), 'Color', 'yellow', 'LineWidth', 5);
    RGB = insertShape(RGB, 'Rectangle', uint32(rect_old_show), 'Color', 'green', 'LineWidth', 5);
    imshow(RGB);
end
%% Save the file
save('../results/sylvseqrects.mat', 'rects');
%% Get the images from frames: 1, 200, 300, 350, and 400
i = 400;
rect_show = [rects(i,1), rects(i,2), ...
        abs(rects(i,1)-rects(i,3)), abs(rects(i,2)-rects(i,4))];
rect_old_show = [rects_old(i,1), rects_old(i,2), ...
    abs(rects_old(i,1)-rects_old(i,3)), abs(rects_old(i,2)-rects_old(i,4))];
% Display the image
yellow = uint8([255 255 0]);
green = uint8([0 255 0]);
RGB = repmat(frames(:,:,i), [1,1,3]);
RGB = insertShape(RGB, 'Rectangle', uint32(rect_show), 'Color', 'yellow', 'LineWidth', 5);
RGB = insertShape(RGB, 'Rectangle', uint32(rect_old_show), 'Color', 'green', 'LineWidth', 5);
imshow(RGB)
