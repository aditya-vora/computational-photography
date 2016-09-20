function [NNF, ltImg, IMF, invIMF] = getlatentImages(pyramidSrc, pyramidRef)
%%
% This function computes all the parameters in the algorithm i.e Nearest
% neighbour field latentImages, Intensity mapping function and inverse
% Intensity mapping function
% PARAMETERS:
% NNF = Nearest neighbour field
% ltImg = Latent Image
% IMF = Intensity Mapping Function
% invIMF = Inverse Intensity Mapping Function
% pyramidSrc = Initial pyramid of Source Images
% pyramidRef = Initial pyramid of Referance Images

%%
% Get the number of pyramid levels
pyrlevels = numel(pyramidSrc);
% Init NNF 
pSize = 9;

%%
% Obtain the nearest neighbour field between two images through patch match
% after histogram equilization
[NNF] = histPatchMatch(pyramidRef{pyrlevels}, pyramidSrc{pyrlevels});
NNF(:,:,1) = padarray(NNF(1:end-pSize,1:end-pSize,1),[pSize, pSize], 'replicate', 'post'); 
NNF(:,:,2) = padarray(NNF(1:end-pSize,1:end-pSize,2),[pSize, pSize], 'replicate', 'post'); 

%%
% Compute the intensity mapping function and inverse intensity mapping
% function of both the images
IMF    = computeimfhist(im2double(pyramidRef{1}), im2double(pyramidSrc{1}));
invIMF = computeimfhist(im2double(pyramidSrc{1}), im2double(pyramidRef{1}));

itersLevel = 2;
maxIters = itersLevel*pyrlevels+1;

% Iterate through all pyramid levels
for iLevel = pyrlevels:-1:1
    intensityMappedRef = transfercolor(im2double(pyramidRef{iLevel}), IMF);
    
    ltImg = intensityMappedRef;
    maxIters = maxIters-itersLevel;        
    
end

end

