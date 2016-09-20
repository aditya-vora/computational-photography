function [ alpha ] = matting( I1, I2 )
% Function finds the appropriate matte based on known foreground and
% background. 
% function [alpha] = matting(I1, I2)
% alpha = output argument which is equal to the matte.
% I1 = input argument with known background.
% I2 = input argument with known background.

alpha = zeros(size(I1,1), size(I1,2),... % Initialize alpha
    size(I1,3));
%%

% Applying the formula to get all the three channels of alpha.
for i = 1:size(alpha(:,:,1),1)
    for j = 1:size(alpha(:,:,1),2)
        alpha(i,j,1) = 1 - ((I1(i,j,1) - I2(i,j,1))/...
            (I1(1,1,1) - I2(1,1,1)));  
        alpha(i,j,2) = 1 - ((I1(i,j,2) - I2(i,j,2))/...
            (I1(1,1,2) - I2(1,1,2)));
        alpha(i,j,3) = 1 - ((I1(i,j,3) - I2(i,j,3))/...
            (I1(1,1,3) - I2(1,1,3)));
    end
end
end

