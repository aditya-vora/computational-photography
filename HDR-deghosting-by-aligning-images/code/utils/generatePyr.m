function [pyrImg] = generatePyr( src )
% Get the pyramid spacing
pyramid_spacing = 2; 
sampleRatio = .5; 
nLevel  = 1 + ceil( log(min(size(src, 1), size(src,2))/32) ...
    / log(pyramid_spacing) ); 
factor            = sqrt(2);  

% Get the value of sigma for the gaussian kernel 
smooth_sigma = sqrt(pyramid_spacing)/factor; 

% Select the appropriate filter kernel which is the gaussian kernel
filterKernel = fspecial('gaussian', 2*round(1.5*smooth_sigma) +1, smooth_sigma);

% Initialize a pyramid
pyrImg   = cell(nLevel,1);
tmp = src;

% First layer is the source image itself
pyrImg{1}= tmp;

for iLevel = 2:nLevel
    
    minValue = min(tmp(:));
    maxValue = max(tmp(:));
    
    % Kernel filtering
    tmp = imfilter(tmp, filterKernel, 'corr', 'symmetric', 'same');
    
    % Get the size of the resized image in the pyramid given the sampling ratio
    sizeImg  = round([size(tmp,1) size(tmp,2)] * sampleRatio);
    
    % Resize the pyramid image
    tmp = imresize(tmp, sizeImg, 'bilinear', 0); % Disable antialiasing, old version for cluster
    
    % Thresholding to the valid range
    tmp( tmp < minValue ) = minValue;
    tmp( tmp > maxValue ) = maxValue;
    
    pyrImg{iLevel} = tmp;
end
end

