%% CV Spring 2016 - Cole Gulino
% testCarSequenceWithTemplateCorrection.m
% Description: Run the script to track the car from each image frame in the
% video using template correction
clear;
%% Load the video frames
load('../data/carseq.mat');
%% Get the constants and preallocate values
no_frames = size(frames,3);
rects = zeros(no_frames, 4);
th = 0.3;
U = [];
V = [];
rects(1,:) = [60, 117, 146, 152];
rect_show = [rects(1,1), rects(1,2), ...
        abs(rects(1,1)-rects(1,3)), abs(rects(1,2)-rects(1,4))];
yellow = uint8([255 255 0]);
shapeInserter = vision.ShapeInserter('BorderColor', 'Custom', 'CustomBorderColor', yellow);
RGB = repmat(frames(:,:,1), [1,1,3]);
J = step(shapeInserter, RGB, uint32(rect_show));
figure;
imshow(J);
X = meshgrid(rects(1,1):rects(1,3),1); % Meshgrid of column values for rectangle
Y = meshgrid(rects(1,2):rects(1,4),1); % Meshgrid of row values for rectangle
It = im2double(frames(:,:,1));
T = It(Y,X);
%% Get the rectangles of the frame
for i = 2:no_frames
    % Get the images
    It1 = im2double(frames(:,:,i));
    % Run Lucas Kanade
    [u, v] = LucasKanadeWTC(T, It1, rects(i-1,:));
    rects(i,1) = rects(i-1,1) + u;
    rects(i,2) = rects(i-1,2) + v;
    rects(i,3) = rects(i-1,3) + u;
    rects(i,4) = rects(i-1,4) + v;
    % Display the image
    % Get a rectangle for showing on video
    rect_show = [rects(i,1), rects(i,2), ...
        abs(rects(i,1)-rects(i,3)), abs(rects(i,2)-rects(i,4))];
%     rect_old_show = [rects_old(i,1), rects_old(i,2), ...
%         abs(rects_old(i,1)-rects_old(i,3)), abs(rects_old(i,2)-rects_old(i,4))];
    % Display the image
    RGB = repmat(frames(:,:,i), [1,1,3]);
    RGB = insertShape(RGB, 'Rectangle', uint32(rect_show), 'Color', 'yellow', 'LineWidth', 5);
%     RGB = insertShape(RGB, 'Rectangle', uint32(rect_old_show), 'Color', 'green', 'LineWidth', 5);
    imshow(RGB);
end
%% Store rects
save('../results/carseqrects-wcrt.mat', 'rects');
%% Show the frames
i = 400;
load('../results/carseqrects.mat');
rects_old = rects;
load('../results/carseqrects-wcrt.mat');
rect_show = [rects(i,1), rects(i,2), ...
    abs(rects(i,1)-rects(i,3)), abs(rects(i,2)-rects(i,4))];
rect_old_show = [rects_old(i,1), rects_old(i,2), ...
    abs(rects_old(i,1)-rects_old(i,3)), abs(rects_old(i,2)-rects_old(i,4))];
RGB = repmat(frames(:,:,i), [1,1,3]);
RGB = insertShape(RGB, 'Rectangle', uint32(rect_show), 'Color', 'yellow', 'LineWidth', 5);
RGB = insertShape(RGB, 'Rectangle', uint32(rect_old_show), 'Color', 'green', 'LineWidth', 5);
imshow(RGB);
