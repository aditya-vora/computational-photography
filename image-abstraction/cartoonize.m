function out = cartoonize(I)
%% Define the parameters of the bilateral filter.
K = 5;            % Kernel size of the bilateral filter.
sigma = [3,2];  % Sigma of the bilateral filter.

%%

% Apply bilteral filter recursively. For two times before applying the 
% quantization process.
I = bilateralFilter(I, K, sigma);
I = bilateralFilter(I, K, sigma);
% Select the quantization level.
level = 10;
% Apply the quantization on the L channel.
I1 = quant(I, level);

%%

% Apply bilateral filter to the image for another two times.
% before going for edge detection.
I = bilateralFilter(I, K, sigma);
I = bilateralFilter(I, K, sigma);
% Select the parameters for the edge detection
sigmaE = 0.5;
T = 0.99;
phiE = 1;
% Apply the edge detection technique with the defined parameters.
I2 = detectEdge(I, sigmaE, T, phiE);
out = I1.*I2;  % Combine the quantized image I1 and edges I2

end

