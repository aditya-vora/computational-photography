function [ hdrIm ] = GetHDR(filenames, gRed, gGreen, gBlue, wt, expTime)
% Function Generates a hdr radiance map from a set of pictures
%
% INPUT ARGUMENTS:
% filenames: a list of filenames containing the differently exposed
% pictures used to make a hdr image.
% gRed: camera response function for the red color channel
% gGreen: camera response function for the green color channel
% gBlue: camera response function for the blue color channel
% wt : weights of the pixels
% expTime : exposure time of each image in the stack
%%
numExposures = size(filenames,2); % Get the image stack
image = imread(filenames{1});     % Read the first image   
% pre-allocate resulting hdr image
hdrIm = zeros(size(image));
sum = zeros(size(image));
for i=1:numExposures
    image = double(imread(filenames{i}));
    wij = wt(image + 1);        
    sum = sum + wij;
    E(:,:,1) = (gRed(image(:,:,1) + 1) - expTime(1,i));
    E(:,:,2) = (gGreen(image(:,:,2) + 1) - expTime(1,i));
    E(:,:,3) = (gBlue(image(:,:,3) + 1) - expTime(1,i));
    hdrIm = hdrIm + (wij .* E);
end
% normalize
hdrIm = hdrIm ./ sum;
hdrIm = exp(hdrIm);
    