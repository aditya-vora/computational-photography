clc; clear all; close all;
%%

% Read the image 
image = imread('TajMahal.jpg');
image = imresize(image, 0.5);
figure;
imshow(image);
title('Original RGB Image');
fprintf('Size of the Original Image: %d x %d\n',size(image,1), size(image,2));
%%

% Calling of the SeamCarving function that takes the image, 
% number of columns as input.
OutPut = SeamCarving(image, 20);

%%

% Display the result
figure;
imshow(OutPut);
title('Image After seam Carving');
fprintf('Size of the seam Carved Image: %d x %d\n',size(OutPut,1),size(OutPut,2));

