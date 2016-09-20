function [ OutputImage ] = objectRemove( image, sR, eR, sC, eC)
% Function removes a area of interest from an image given the 
% region to be removed as input.
SeamCarvedIm = image;
for i = 1:eC
    % Find the energy map.
    energy = double(energyIm(SeamCarvedIm));
    
    % Assign very high negative value to the energy map 
    % So that the seam forcefully passes through the region that is to 
    % be removed. Here all the values in the region to be removed 
    % are scaled by -50. Here the energy map dimension needs to be 
    % changed to account for accurate energy calulation.
    
    energy(sR:eR, sC:eC-i) = double(-50)*energy(sR:eR, sC:eC-i);
    % Find the minimum energy path
    M = seamImage(energy);
    % Find the seam Path
    seam = backTrack(M);
    % Remove the Seam from the image
    % Here only 
    SeamCarvedIm = removeSeam(SeamCarvedIm,seam);
    %SeamCarvedMask = SeamCut(mask,seam);
end
OutputImage = SeamCarvedIm;
end

