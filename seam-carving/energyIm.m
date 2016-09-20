% Function returns the energy map of the input image I given as 
% input. 
function res = energyIm(I)
% Performs summation across all the channels of the energy values
% Computed from energyGrey function for all the channels.

    res = energyGrey(I(:, :, 1)) + energyGrey(I(:, :, 2)) ...
        + energyGrey(I(:, :, 3));
end

function res = energyGrey(I)
% find the energy map by finding the gradients across X and Y direction
% after defining the kernels [-1, 0, 1] and [-1; 0; 1].
res = abs(imfilter(I, [-1,0,1], 'replicate')) + ...
        abs(imfilter(I, [-1;0;1], 'replicate'));
end
