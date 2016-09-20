function [ im,nsr ] = weiner( I1, I2, PSF, sig)
% Function does the deconvolution operation on the degraded in 
% order to improve the quality of the image. 
% Function description:
% function [im] = weiner(I1, I2, PSF, sig)
% im = output image
% nsr = noise to signal power ratio
% I1 = original image
% I2 = degraded image
% PSF = point spread function i.e. the blur kernel or the defocus
% blur kernel
% sig = standard deviation of the noise signal
[m,n] = size(I1);
% Taking the DFT of the degraded image
I2f = fft2(I2);
% Taking the DFT of the point spread function after padding the
% PSF kernel to make the size of the PSF kernel equal to the image
PSF_F = fft2(PSF,m,n);
% Finding the variance of the original image
var_I1 = var(im2double(I1(:)));
nsr = (sig^2/var_I1);
% Finding the kernel
Gf = conj(PSF_F)./(abs(PSF_F).^2 + nsr);
% Applying the kernel on the degraded image in the frequency domain
im_f = Gf.*I2f;
% Taking the real part of the spectrum
im = real(ifft2(im_f));
end

