% Assignment 5 : Given two images create a seamless composite 
% image using Poisson Image Editing
clc; clear all; close all;
%%
% Read the images of moon and bird
img_lena = rgb2gray(imread('lena.png'));
img_girl = rgb2gray(imread('girl.png'));

figure;
imshow(img_lena);
figure;
imshow(img_girl);

img_lena = double(img_lena);
img_girl = double(img_girl);

%%
% Define the horizontal and vertical kernels for computing the
% gradient.
Kh = [ 0,-1, 1 ];
Kv = [ 0;-1; 1 ];
Lenah = imfilter(img_lena,Kh,'replicate');
Lenav = imfilter(img_lena,Kv,'replicate');
Girlh = imfilter(img_girl,Kh,'replicate');
Girlv = imfilter(img_girl,Kv,'replicate');
%%
X = img_lena;
Fh = Lenah;
Fv = Lenav;
%%
% Define the region to be blended
wid = 57;
ht = 16;
LenaX = 123;
LenaY = 125;
GirlX = 89;
GirlY = 101;
%%
% Replace the region in X with that in girl
X(LenaY:LenaY+ht,LenaX:LenaX+wid) = ...
    img_girl(GirlY:GirlY+ht,GirlX:GirlX+wid);
% Replace the region in F with that in Girllap
Fh(LenaY:LenaY+ht,LenaX:LenaX+wid) = ...
    Girlh(GirlY:GirlY+ht,GirlX:GirlX+wid);
Fv(LenaY:LenaY+ht,LenaX:LenaX+wid) = ...
    Girlv(GirlY:GirlY+ht,GirlX:GirlX+wid);
%%
% Define the mask for the region to be blended
msk = zeros(size(X));
msk(LenaY:LenaY+ht,LenaX:LenaX+wid) = 1;
%%
% Solve the poisson equation using poissonSolver giving the 
% mask and number of iterations as the input.
Y = solPoisson(X,Fh,Fv,msk,1000);
figure;
imshow(uint8(Y))


