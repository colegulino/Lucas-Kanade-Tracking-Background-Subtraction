%% CV Spring 2016 - Cole Gulino
% testAerialSequence.m
% Description: Run the script to detect motion
clear;
%% Load the video frames
load('../data/aerialseq.mat');
%% Get the constants and preallocate values
no_frames = size(frames,3);
masks = zeros(size(frames(:,:,1),1), size(frames(:,:,1),2), no_frames-1);
%% Main loop to detect motion between frames
figure;
for i = 2:no_frames
    masks(:,:,i-1) = SubtractDominantMotion(frames(:,:,i), frames(:,:,i-1));
    imshow(imfuse(frames(:,:,i), masks(:,:,i-1)));
end
%% Save the masks
save('../results/aerialseqmasks.mat','masks');