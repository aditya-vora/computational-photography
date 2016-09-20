function out = bilateralToneMap( hdr, dr, gamma )
% Functions performs the tone mapping operation for HDR images
% using the bilateral filter
% INPUT ARGUMENTS:
% hdr : The hdr radiance map obtained from the exposure stack.
% dr  : Scale factor
% gamma: Gamma value for gamma correction
%%
% Get the luminance map of the HDR original image
I = (hdr(:,:,1)+hdr(:,:,2)+hdr(:,:,3))/3;

% Get the chrominance channels.
r = hdr(:,:,1)./I;
g = hdr(:,:,2)./I;
b = hdr(:,:,3)./I;

% Compute the log intensity 
L = log10(I);
[m,n] = size(I);
% Filter log intensity with a bilateral filter
sigma_d = 0.02*sqrt(m^2+n^2);
sigma_r = 0.04;
B = bilateralFilter(L, 5, [sigma_d,sigma_r]);

% Computes the detail layer
D = L-B;

% The offset is such that the maximum intensity of the base is 1. 
% Since the values are in the log domain, o = max(B).
o = max(B(:));

% The scale is set so that the output base has dR stops of dynamic 
% range, i.e., s = dR / (max(B) - min(B)). Try values between 2 and 8 
% for dR, that should cover an interesting range. Values around 4 or 5 
% should look fine.
s = dr/(max(B(:)) - min(B(:)));
Bd = (B-o).*s;

% Reconstruct the log intensity
O = 2.^(Bd+D);

% Put back the colors
R = O.*r;
G = O.*g;
B = O.*b;

% Apply gamma compression
out(:,:,1) = R;
out(:,:,2) = G;
out(:,:,3) = B;
out = out.^gamma;
end

