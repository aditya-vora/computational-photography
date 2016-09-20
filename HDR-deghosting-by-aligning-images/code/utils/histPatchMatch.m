function  [uv] = histPatchMatch(imgA, imgB)
% This function computes the histogram equilization of the both input
% images and returns the matched patches in both the images.
% PARAMETERS:
% imgA = input image A
% imgB = input image B
% uv = Nearest Neighbour Field obtained after Patch Match
%%
% Perform histogram equilization on both the images
histeqImgA = histeq(rgb2gray(imgA));
histeqImgB = histeq(rgb2gray(imgB));
histeqImgA = repmat(histeqImgA, [1 1 3]);
histeqImgB = repmat(histeqImgB, [1 1 3]);

%%
% Obtain the matched patches from both the images
uv = patchmatch(im2uint8(histeqImgA), im2uint8(histeqImgB), 9);
end

