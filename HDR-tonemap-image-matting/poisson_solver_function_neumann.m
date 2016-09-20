
%=========================================================
% Matlab code for ECCV 2006 paper
% Copyright: Amit Agrawal, 2006
% http://www.umiacs.umd.edu/~aagrawal/
% Permitted for personal use and research purpose only
% Refer to the following citations:
 
%   1.  A. Agrawal, R. Raskar and R. Chellappa, "What is the Range of
%   Surface Reconstructions from a Gradient Field? European Conference on
%   Computer Vision (ECCV) 2006
 
%   2.  A. Agrawal, R. Chellappa and R. Raskar, "An Algebraic approach to surface reconstructions from gradient fields?
%   Intenational Conference on Computer Vision (ICCV) 2006
%=========================================================

function [rec] = poisson_solver_function_neumann(gx,gy)

% Least squares solution
% Poisson Reconstruction Using Neumann boundary conditions
% Input gx and gy
% gradients at boundary are assumed to be zero
% Output : reconstruction
% Author: Amit Agrawal, 2004

disp('=======================================================')
disp('Solving Poisson Equation using Neumann');


[H,W] = size(gx);

gx(:,end) = 0;
gy(end,:) = 0;

% pad
gx = padarray(gx,[1 1],0,'both');
gy = padarray(gy,[1 1],0,'both');


gxx = zeros(size(gx)); 
gyy = zeros(size(gx)); 
f = zeros(size(gx)); 

j = 1:H+1;
k = 1:W+1;

% Laplacian
gyy(j+1,k) = gy(j+1,k) - gy(j,k);
gxx(j,k+1) = gx(j,k+1) - gx(j,k);
f = gxx + gyy;
f = f(2:end-1,2:end-1);
clear j k gxx gyy gyyd gxxd gx gy


%compute cosine transform
fcos = dct2(f);
clear f

%compute eigen values
[x,y] = meshgrid(0:W-1,0:H-1);
denom = (2*cos(pi*x/(W))-2) + (2*cos(pi*y/(H)) - 2);
clear x y
size(fcos(2:end))
size(denom(2:end))
%divide. 1st element of denom will be zero and 1st element of fcos and
%after division should also be zero; so divided rest of the elements
fcos(2:end) = fcos(2:end)./denom(2:end);
clear denom

% compute inverse dct2
rec = idct2(fcos);
