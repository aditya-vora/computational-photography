function [ phi ] = Phi( H, alpha, beta )

% Function computes the Attenuation Function Phi using the 
% Pyramid values and alpha and beta
% function [ phi ] = Phi( H, alpha, beta)
% phi = final phi pyramid as output
% H = gradient pyramid given as input
% alpha = trade-off parameter
% beta = trade-off parameter.

phi = cell(1,numel(H)); % Find the dimension of the pyramid
dim = size(H);
for i = 1:dim(2)
    phi{i} = (alpha./H{i}).*((H{i}./alpha).^beta); % Compute the phi 
    % each image in the pyramid.
end

