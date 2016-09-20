function SeamCarvedIm  = SeamCarving( I, cols )
%% 
% Function that performs the seam Carving operation of the input image I,
% and removes a number of rows and number of columns in a content aware 
% fashion
% function SeamCarvedIm = SeamCarving(I, rows, cols)
% SeamCarvedIm = output image after removing certain number of 
% rows and columns from the input image I.
% I = input Image
% rows = number of rows to be removed
% cols = number of columns to be removed from the input images I.

SeamCarvedIm = I; % Assign initial image as SeamCarved Image.
%%
for i = 1:cols    % Find vertical Seams 
    energy = energyIm(SeamCarvedIm); % Find the energy map of the Image.
    % Finds the cummulative energy measure through dynamic programming.
    M = seamImage(energy);
    % Find the locations through which the seam passes by back Tracking
    seam = backTrack(M); 
    % Removes the appropriate seam from the image
    SeamCarvedIm = removeSeam(SeamCarvedIm,seam); 
end


