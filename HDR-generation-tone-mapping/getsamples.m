function [ ZRed, ZGreen, ZBlue ] = getsamples( filenames, numPixels )
% Function samples the image stack which is given as the input
% so that we can use that samples in order to compute the camera
% response function
% INPUT ARGUMENTS:
% filenames: Images filenames list which are needed to sample.
% numPixels: Get the total number of pixels in an image
% Get the number of differently exposed image.
%%

numExposures = length(filenames);

% We need to satisfy N(P-1) > (Zmax - Zmin)
% N = (255 * 2) / (P-1) fulfills the condition.    
% Here we have assumed that Zmax = 256 and Zmin = 1
samples = ceil(255*2 / (numExposures - 1)) * 2;

% Step shows at what interval we need to sample the image
step = numPixels / samples;

% Get the indices that we need to sample.
sampleInd = floor((1:step:numPixels));
sampleInd = sampleInd';

% Sampled images are contained in ZRed, ZGreen, ZBlue.
ZRed = zeros(samples, numExposures);
ZGreen = zeros(samples, numExposures);
ZBlue = zeros(samples, numExposures);

for i=1:numExposures
    % read the image
    im = imread(filenames{i});
    % Extract the red channel 
    rChannel = im(:,:,1);
    % Sample the red channel in the image
    red = rChannel(sampleInd);
    % Get the green channel from the image
    gChannel = im(:,:,2);
    % Sample the green channel in the image
    green = gChannel(sampleInd);
    % Get the blue channels in the image
    bChannel = im(:,:,3);
    % Sample the image based on the sampling stepsize.
    blue = bChannel(sampleInd);
    % Assign the samples to ZRed, ZGreen and ZBlue.
    ZRed(:,i) = red;
    ZGreen(:,i) = green;
    ZBlue(:,i) = blue;
end

end

