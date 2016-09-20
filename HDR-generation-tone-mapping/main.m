
clc; clear all; close all; 
%%
% Read the files in the exposure stack.
filenames = {'office_1.jpg', 'office_2.jpg', 'office_3.jpg', ...
         'office_4.jpg', 'office_5.jpg', 'office_6.jpg'};
% Get the exposure times
exposures = [0.0333, 0.1000, 0.3333, 0.6250, 1.3000, 4.0000];
% Read the first image to get the total number of pixels.
tempImg = imread(filenames{1});
numPixels = size(tempImg,1) * size(tempImg,2);
% Plot all the images in the exposure stack.
figure;
subplot(2,3,1);
imshow(filenames{1}); 
title('Exposure Time = 0.0333');
subplot(2,3,2);
imshow(filenames{2}); 
title('Exposure Time = 0.1000');
subplot(2,3,3);
imshow(filenames{3});
title('Exposure Time = 0.3333');
subplot(2,3,4);
imshow(filenames{4});
title('Exposure Time = 0.6250');
subplot(2,3,5);
imshow(filenames{5});
title('Exposure Time = 1.3000');
subplot(2,3,6);
imshow(filenames{6});
title('Exposure Time = 4.0000');

%%
% Define lamda smoothing factor used in the calculation of the camera
% Response function.
lambda = 50;
fprintf('Getting the weight function of all the pixels\n');
% Compute the weight values for each pixel.
weights = zeros(1,256); % Preallocate the weight matrix
zmax = 256;             % Get the maximum pixel intensity value
zmin = 1;               % Get the minimum pixel intensity value
for i=1:256
    if i <= 0.5 * (zmin + zmax) 
        weights(i) = ((i - zmin) + 1); % Compute the weights given by the formula in the paper!
    else
        weights(i) = ((zmax - i) + 1);
    end
end
%%
% load and sample the images
numExposures = length(filenames);
[zR, zG, zB] = getsamples(filenames, numPixels);
B = zeros(size(zR,1)*size(zR,2), numExposures);
for i = 1:numExposures
    B(:,i) = log(exposures(i));
end
%%
% solve the system for each color channel
fprintf('gSolve for red channel\n')
[gRed,lERed]=gsolve(zR, B, lambda, weights);
fprintf('gSolve for green channel\n')
[gGreen,lEGreen]=gsolve(zG, B, lambda, weights);
fprintf('gSolve for blue channel\n')
[gBlue,lEBlue]=gsolve(zB, B, lambda, weights);
%%
% Display the Camera response function
y = (0:255);
figure;
hold on;
plot(gRed, y, 'r-', gGreen,y , 'g-', gBlue, y, 'b-', 'linewidth', 2);
xlabel('log Exposure X');
ylabel('Pixel Value Z');
legend('Red Channel Camera Response Function', 'Green Channel Camera Response Function', 'Blue Channel Camera Response Function')
hold off;
%%

% compute the hdr radiance map
fprintf('Computing hdr image\n')
hdrImage = GetHDR(filenames, gRed, gGreen, gBlue, weights, B);
figure;
imshow(hdrImage);
title('High Dynamic Range image generated from stack of images with different exposure times');

%%
% Perform tone mapping using bilateral tone map.
dr = 6; % Scale Factor vary between [2,8] depending on the quality of image
gamma = 0.45; % Gamma value for gamma compression
out = bilateralToneMap(hdrImage, dr, gamma);
%%
figure;
imshow(out);
title('Final Tone Mapped Image using Bilateral Filter')