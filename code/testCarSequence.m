%% CV Spring 2016 - Cole Gulino
% testCarSequence.m
% Description: Run the script to track the car from each image frame in the video
clear;
%% Load the video frames
load('../data/carseq.mat');
%% Get the constants and preallocate values
no_frames = size(frames,3);
rects = zeros(no_frames, 4);
rects(1,:) = [60, 117, 146, 152];
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
    [u, v] = LucasKanade(It, It1, rects(i-1,:));
    % Update rects with the new rectangle
    rects(i,1) = rects(i-1,1) + u;
    rects(i,2) = rects(i-1,2) + v;
    rects(i,3) = rects(i-1,3) + u;
    rects(i,4) = rects(i-1,4) + v;
    % Get a rectangle for showing on video
    rect_show = [rects(i,1), rects(i,2), ...
        abs(rects(i,1)-rects(i,3)), abs(rects(i,2)-rects(i,4))];
    % Display the image
    yellow = uint8([255 255 0]);
    shapeInserter = vision.ShapeInserter('BorderColor', 'Custom', 'CustomBorderColor', yellow);
    RGB = repmat(frames(:,:,i), [1,1,3]);
    J = step(shapeInserter, RGB, uint32(rect_show));
    imshow(J);
end
%% Store rects
save('../results/carseqrects.mat', 'rects');
%% Print rectangle and image of frames: 1, 100, 200, 300, and 400
frame_no = [1 100 200 300 400];
rect = rects(400,:);
rect_show = [rect(1), rect(2), ...
        abs(rect(1)-rect(3)), abs(rect(2)-rect(4))];
yellow = uint8([255 255 0]);
shapeInserter = vision.ShapeInserter('BorderColor', 'Custom', 'CustomBorderColor', yellow);
RGB = repmat(frames(:,:,400), [1,1,3]);
J = step(shapeInserter, RGB, uint32(rect_show));
figure;
imshow(J);
