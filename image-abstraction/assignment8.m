clc; clear all; close all;
%%

% Read the image and import the image as double.
im = im2double(imread('IMG_1151.JPG'));
im = imresize(im, 0.2);
%%
% Convert the color space from RGB to LAB.
c = makecform('srgb2lab');
LabIm = applycform(im, c); % Get the LAB image

%%

% cartoonize the image. Here only the L channel of the LabIm image 
% is given as input.
out = cartoonize(LabIm(:,:,1));
% Append the other two channels
out(:,:,2) = LabIm(:,:,2);
out(:,:,3) = LabIm(:,:,3);
% Change the colorspace from LAB to RGB
out = applycform(out, makecform('lab2srgb'));

%%
% Display the image.
figure;
imshow(im);
title('Original RGB Image');
figure;
imshow(out);
title('Cartoonized Image');