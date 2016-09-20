clc; clear all; close all;

%%
% Import the Blue Screen and the green Screen Image.
BlueScreen = double(imread('blue.png'));
GreenScreen = double(imread('green.png'));
figure;
imshow(uint8(BlueScreen));
title('Image with Blue Screen Back Ground');
figure;
imshow(uint8(GreenScreen));
title('Image with Green Screen Back Ground');

%%
% Compute the alpha value from the matting function
alpha = matting(BlueScreen, GreenScreen);
figure;
imshow(alpha);
title('Display of the alpha matte that is obtained');
%%
% Extracting the foreground from the Blue Screen image.
FG = alpha.*BlueScreen;
figure;
imshow(FG);
title('Foreground Extracted after applying the matte')

% Import the background to which the foreground is to be 
% transferred.

BG = double(imread('background.JPG'));
figure;
imshow(uint8(BG));
title('Background on which the matte is to be applied');
% Find the final Matted image from the equation 
% I = alpha*Foreground + (1 - alpha)*Background

I = alpha.*FG + (1.0 - alpha).*BG;

% Display the final Matted image
figure;
imshow(uint8(I));
title('Final image obtained after Matting');
