function [ out ] = divideBlocks( I, patchSize )
% Function divides the image into blocks 
% PARAMETERS:
% I = input image
% patchSize = size of the patch into which the image is divided
% out = output image.

[rows, columns, Channels] = size( I );
blockSizeR = patchSize(1); % Rows in block.
blockSizeC = patchSize(2); % Columns in block.
wholeBlockRows = floor(rows / blockSizeR);
blockVectorR = [blockSizeR * ones(1, wholeBlockRows), rem(rows, blockSizeR)];
% Figure out the size of each block in columns. 
wholeBlockCols = floor(columns / blockSizeC);
blockVectorC = [blockSizeC * ones(1, wholeBlockCols), rem(columns, blockSizeC)];
if Channels > 1
	% It's a color image.
	out = mat2cell(I, blockVectorR, blockVectorC, Channels);
else
	out = mat2cell(I, blockVectorR, blockVectorC);
end


end

