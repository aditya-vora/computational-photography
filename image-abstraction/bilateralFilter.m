function out = bilateralFilter( I, K, SIGMA )
% function performs bilateral filter operation on an image.
% SYNTAX: out = bilateralFilter(I, K, SIGMA)
% I = input image
% K = kernel size of which the filter is to be applied.
% SIGMA = SIGMA defines the space parameter and the range parameter
%         of the bilateral filter.
% out = Output Image.

% Apply either grayscale or color bilateral filtering.
if size(I,3) == 1   % For grayscale image
   out = bfiltG(I,K,SIGMA(1),SIGMA(2));
else                % For color image
   out = bfiltC(I,K,SIGMA(1),SIGMA(2));
end
end

%%
function out = bfiltG(I, K, ss, sr)
% function applies the bilateral filter on the grayscale image.
% ARGUMENTS: 
% out = output image after applying the bilateral filter.
% I = input image
% ss = space parameter
% sr = range parameter
G = fspecial('gaussian', 2*K+1, ss); % define a gaussian kernel 
                                    % of window size 2*K+1 and 
                                    % standard deviation as ss
dim = size(I);
out = zeros(dim);                   % Define the output image
for i = 1:dim(1)
    for j = 1:dim(2)
        % Select the region depending on the kernel size.
        imin = max(i-K, 1);
        imax = min(i+K, dim(1));
        jmin = max(j-K, 1);
        jmax = min(j+K, dim(2));
        % Extract out the region
        region = I(imin:imax, jmin:jmax);
        H = exp(-(region - I(i,j)).^2/(2*sr.^2));
        F = H.*G((imin:imax) - i + K + 1,(jmin:jmax) - j + K + 1);
        % Obtain the final out
        out(i,j) = sum(F(:).*region(:))/sum(F(:));
    end
end
end
%%
function out = bfiltC(I,K,ss,sr)
% function applies the bilateral filter on the color image.
% ARGUMENTS: 
% out = output image after applying the bilateral filter.
% I = input color image
% ss = space parameter
% sr = range parameter

% Define a gaussian kernel based on the space sigma parameter.
G = fspecial('gaussian', 2*K+1, ss);
dim = size(I); % Get the dimension of the image 
out = zeros(dim); % Get the dimension of the output image
for i = 1:dim(1)
   for j = 1:dim(2)
         % Extract local region.
         % Extract the region based on the kernel size
         iMin = max(i-K,1);
         iMax = min(i+K,dim(1));
         jMin = max(j-K,1);
         jMax = min(j+K,dim(2));
         % Define the region on which the filter is to be applied
         region = I(iMin:iMax,jMin:jMax,:);
      
         % Compute Gaussian range weights.
         dR = region(:,:,1)-I(i,j,1);
         dG = region(:,:,2)-I(i,j,2);
         dB = region(:,:,3)-I(i,j,3);
         % Compute the intensity map on the gaussian kernel
         H = exp(-(dR.^2+dG.^2+dB.^2)/(2*sr^2));
      
         % Calculate bilateral filter response.
         F = H.*G((iMin:iMax)-i+K+1,(jMin:jMax)-j+K+1);
         norm_F = sum(F(:));
         % Normalize the final output
         out(i,j,1) = sum(sum(F.*region(:,:,1)))/norm_F;
         out(i,j,2) = sum(sum(F.*region(:,:,2)))/norm_F;
         out(i,j,3) = sum(sum(F.*region(:,:,3)))/norm_F;
                
   end
end
end
    



