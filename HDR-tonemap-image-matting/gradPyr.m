function [ G, Phase ] = gradPyr( Pyr )

% Function computes the Gradient of each image in the pyramid.
% [ G, Phase ] = gradPyr(Pyr)
% G = Computed Gradient pyramid given as the output argument
% Phase = Phase of each gradient image in the pyramid
% Pyr = Pyramid of images given as input.

dim = size(Pyr); % Get the length og the pyramid

G = cell(1,numel(Pyr)); % Initialize the Gradient Pyramid 
Phase = cell(1,numel(Pyr));% Initialize the phase

% Compute the gradient of each level in the pyramid.
for i = 1:dim(2)
    [G{i}, Phase{i}] = imgradient(Pyr(i).img);
    G{i} = G{i}./(2^(i+1));
end

