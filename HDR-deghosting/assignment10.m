clc; clear all; close all;
%%
% Add the path of the images and utils.
warning('off', 'all');
addpath('images');
addpath('utils');
% Get the list of images in the images folder.
imageList = dir('images/');
% Create the stack of images
imageStack = cell(1,5);
figure;
for image = 3:numel(imageList)
    imageStack{image-2} = (imread(imageList(image).name));
    
    subplot(2,3,image-2);
    imshow(imageStack{image-2});
    
end

%%
% Set the exposures of the images in the exposure stack.
exposures = [1/500,1/250,1/125,1/60,1/30];
% Get the number of pixels
tempImg = imageStack{1};
numPixels = size(tempImg,1) * size(tempImg,2);
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
numExposures = numel(imageStack);
[zR, zG, zB] = getsamples(imageStack, numPixels);
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
% Get the number of images in the image Stack
numIm = numel(imageStack);
% Get the index of the reference image
refIdx = ceil(numIm/2);
% Get the reference image from the stack
referenceIm = imageStack{refIdx};
figure;
imshow(uint8(referenceIm));
% Get the exposure of the reference image
refExp = exposures(refIdx);
%%
patchSize = [40,40]; % Define the patchsize.
blockStack = cell(1,numIm);
% Divide the images in the stack into blocks
for i = 1:numIm
    blockStack{i} = divideBlocks(imageStack{i}, patchSize);
end
%%
% 40x40 blocks of the reference image.
RefBlocks = blockStack{refIdx};
% Store the final results in the hdr cell
hdr = cell(size(RefBlocks));
for r = 1:size(RefBlocks,1)-1 
    for c = 1:size(RefBlocks,2)-1
        % Retrieve one of the blocks in the  
        refblock = RefBlocks{r,c};
        % Get the iradiance map of one of the HDR block
        irRef(:,:,1) = (gRed(refblock(:,:,1) + 1) - B(1,refIdx));
        irRef(:,:,2) = (gGreen(refblock(:,:,2) + 1) - B(1,refIdx));
        irRef(:,:,3) = (gBlue(refblock(:,:,3) + 1) - B(1,refIdx));
        j=1;
        % Initialize the HDR block
        hdrBlock = zeros(size(refblock));
        sum = zeros(size(refblock));
        for i = 1:numIm
            % Read the images from the stack
            ImBlocks = blockStack{i};
            % Get one of the blocks from the images
            imblock = ImBlocks{r,c};
            % Get the irradiance map of that block of the image
            irIm(:,:,1) = (gRed(imblock(:,:,1) + 1) - B(1,i));
            irIm(:,:,2) = (gGreen(refblock(:,:,2) + 1) - B(1,i));
            irIm(:,:,3) = (gBlue(refblock(:,:,3) + 1) - B(1,i));
            % Get the estimate of the iradiance of the image
            Y = irRef + log(exposures(refIdx)/exposures(i));
            % Compute the error
            err = abs(Y-irIm);
            
            % Set a thresold on the count of the ghost patches
            if length(find(err>0.9))<(0.1*1600)
                image = imblock;
                wij = weights(image + 1);
                sum = sum + wij;
                hdrBlock = hdrBlock + (wij .* irIm);
               
                j = j+1;
            else
                
            end
             
        end
        % Compute the HDR
        hdrBlock = hdrBlock ./ sum;
        hdrBlock = exp(hdrBlock);
        hdr{r,c} = hdrBlock;
        
    end
end      
% Convert into matrix.
hdr = cell2mat(hdr);
hdr = tonemap(hdr);
figure;
imshow(hdr);
title('Final tone mapped HDR image')
% Find the gradient of the image
Kx = [-1, 1]; Ky = [-1; 1];
Gx = imfilter(hdr, Kx, 'replicate');
Gy = imfilter(hdr, Ky, 'replicate');
for i = 1:3
    hdr(:,:,i) = poisson_solver_function_neumann(Gx(:,:,i),Gy(:,:,i));
end
figure;
imshow(hdr);