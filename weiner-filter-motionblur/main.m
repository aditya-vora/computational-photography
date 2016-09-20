% Programming Assignment 2 
% 1. Design a filter and adaptively restore an image 
% corrupted by varying amounts of Gaussian Noise and 
% Motion Blur.
% 2. Design a filter and adaptively restore an image 
% corrupted by varying amounts of Gaussian Noise and 
% Defocus Blur.

% Initialization
clc; clear all; close all;
%%
% PROBLEM 2: Restoring the image in the presence of Defocus 
% Blur and gaussian noise.

% Reading and displaying the original Gray Scale image 
imGray = rgb2gray(im2double(imread('image.png')));
figure;
imshow(imGray);
title('Original Gray Image');


%%
% Creating the defocus blur effect on the image using 
% the 'disk' blur kernel of a predefined disk radius.
% Here the blur kernel is called the point spread 
% function.
PSF = fspecial('disk',5);
% Applying the filtering operation to the Gray
% image
imBlur = imfilter(imGray, PSF, 'circular', 'conv');
figure;
imshow(imBlur);
title('Defocus blurred image with a particular blur radius');
%%
% Add noise 
% Defining Mean of the noise
noise_mean = 0;
% Defining the variance of the noise
i = 0.001;
j = 1;
while (i <= 0.009)
    noise_var = i;
    % Adding noise to the blurred image 
    imBlurNoise = imnoise(imBlur, 'gaussian', noise_mean, noise_var);   
    figure; 
    imshow(imBlurNoise); 
    title(['Blurred and Noisy image with noise varience ',num2str(noise_var)]);
   

    % Applying the weiner filter to the degraded image. 
    [resIm,nsr(j)] = weiner(imGray,imBlurNoise,PSF, sqrt(noise_var));
    
    % Displaying the results
    figure;
    imshow(resIm);
    title(['Weiner Filter Results for recovering the original Image with noise variance ',num2str(noise_var)]);
    i = i + 0.001;
    j = j+1;
end   


%%
% PROBLEM 1: Restoring an image in the presence of motion blur 
% gaussian noise.


%%

% Reading and displaying the original Gray image 
imGray = rgb2gray(im2double(imread('image.png')));
figure;
imshow(imGray);
title('Original Gray Image');


%%
% Creating the motion blur effect on the image of predefined 
% length and orientation.
% Here the blur kernel is called the point spread 
% function.

LEN = 15;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
imMBlur = imfilter(imGray, PSF, 'conv', 'circular');
figure; imshow(imMBlur);
title('Motion Blured image');

%%
% Generating Gaussian noise of a certain mean and standard 
% deviation and adding it to the motion blured image in order 
% to corrupt it.

% Add noise 
% Defining Mean of the noise
noise_mean = 0;
% Defining the variance of the noise
i = 0.001;
j = 1;
while (i <= 0.009)
    noise_var = i;
    % Adding noise to the blurred image 
    imMBlurNoise = imnoise(imMBlur, 'gaussian', noise_mean, noise_var);   
    figure; 
    imshow(imMBlurNoise); 
    title(['Motion Blurred and Noisy image with noise varience ',num2str(noise_var)]);
    
    % Applying the weiner filter to the degraded image. 
    resIm = weiner(imGray, imMBlurNoise,PSF, sqrt(noise_var));
    % Displaying the results
    PSF = fspecial('disk',3);
    % Applying the filtering operation to the gray_scale 
    % image
    resIm = imfilter(resIm, PSF, 'circular', 'conv');
    figure;
    imshow(resIm);
    title(['Weiner Filter Results for recovering the original Image with noise variance ',num2str(noise_var)]);
    i = i + 0.001;
    j = j+1;
end   