function out = detectEdge( I, sigma, T, phiE)
%%
% Function detects the edges from the Image
% SYNTAX:
% out = detectEdge(I, sigma, T, phiE)
% out = output image
% I = input image
% sigma = sigma of the gaussian kernel that is to be used in the DOG 
%         operation
% T = thresold value determines the sensitivity of the edge detector.
% phiE = falloff parameter, determines the sharpness of edge 
%        representations,
h1 = fspecial('gaussian', 5, sigma); % Define the gaussian kernel 
I1 = imfilter(I, h1); % Get the first gaussian filtered image
h2 = fspecial('gaussian', 5, sqrt(1.6)*sigma); % Define another gaussian
                                              % kernel whose sigma is 
                                              % related to the sigma of 
                                              % previous gaussian kernel
I2 = imfilter(I,h2); % Get the second gaussian filtered image.

out = (I1 - T.*I2); % get the final image.
out(out>0) = 1;     % Thresold the edges.
out(out<=0) = 1 + tanh(phiE*out(out<=0));

end

