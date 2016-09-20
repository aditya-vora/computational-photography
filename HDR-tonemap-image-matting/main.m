clc; clear all; close all;
%%
% Develop a gradient domain HDR compression technique to compress 
% the dynamic range of a given HDR image. Display the final tone 
% mapped LDR image and evaluate its quality using dynamic range 
% independent quality metric available online.

% Read the HDR image.
hdrIm = hdrread('Image.hdr');
figure;
imshow(hdrIm);
title('Original High Dynamic Image');
%%
% Change the color from RGB to LAB.
c = makecform('srgb2lab');
hdrLab = applycform(double(hdrIm), c);
%%
% Convert the Luminance Channel to log scale.
hdrL = hdrLab(:,:,1);
LogHdrL = log(double(hdrL));
%%
% Define the alpha and beta values.
alpha = 0.1;
beta = 0.8;
%%
% Form the Gaussian Scale Pyramid of the Log Luminance channel.
Hpyr = Gscale(LogHdrL, 4,[3 3], 1);
%%
% Find the gradient of the pyramid.
[GradH,PhaseH] = gradPyr(Hpyr);

% Form the attenuation function Phi. 
Phi = Phi(GradH, alpha, beta);

% Form the final Phi.
PhiFin = zeros(size(LogHdrL,1),size(LogHdrL,2));
for i = 4:-1:2
    Phi{i-1} = imresize(Phi{i},2).*Phi{i-1};
end
PhiFin = Phi{1};
PhiFin = PhiFin./max(max(PhiFin));
%%
% Find the Gradient of the original Log Scale image. 
[delH,Phase] = imgradient(LogHdrL);

% Apply the Attenuation function on the Gradient Image.
G = delH.*PhiFin;
Kx = [-1, 1]; Ky = [-1; 1];
Gx = imfilter(G, Kx, 'replicate');
Gy = imfilter(G, Ky, 'replicate');

I = poisson_solver_function_neumann(Gx,Gy);

%%
I = exp(I);
FinIm = zeros(size(hdrIm));
Gamma = 0.6;
for i = 1:3
    FinIm(:,:,i) = (((hdrIm(:,:,i))./hdrL).^Gamma).*I;
end
figure;
imshow(FinIm);
title('Low Dynamic Range image obtained after gradient compression');
figure;
subplot(1,2,1); imshow(hdrIm);title('Original High Dynamic Range Image');
subplot(1,2,2); imshow(FinIm);title('Low Dynamic Range image obtained after gradient compression');
%%
% Image comparison using SSIM function
comp = ssim(double(hdrIm), FinIm);

