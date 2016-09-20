clc; clear all; close all;
%%
% Add the corresponding paths 
warning('off','all');
addpath('utils');
patha = 'Data';

% Get the list of data
Datadir = dir(patha);

%%
for index = 3:size(Datadir,1)
    % Get the path of the directory in which the images are stored.
    imagesPath = [patha '/' Datadir(index).name];    
    
    % Get the list of images in the directory
    subdir   = dir(imagesPath);
    
    close all;
    clear im;
    count = 0;
    for inds = 3:length(subdir)
        % Read the images and store them in a stucture
        count = count + 1;
        imageStack{count} = imread([imagesPath '/' subdir(inds).name]);
    end
        
end

%%
% Define the parameters

numImages = numel(imageStack); % Get the number of images   
uv = cell(numImages,1);        % Dense Correspondence in the patch match algorithm between two images
latentImgs = cell(numImages,1);% Latent images which have the exposures from source image S 
                              % and geometry from refrence image R.   
intenMapFun = cell(numImages,1); % Initialize the intensity mapping function
invintenMapFun = cell(numImages,1); % Initialize the inverse intensity mapping function
indexRef = ceil(count/2);        % Initialize the Referance image as the middle image in the stack.
latentImgs{indexRef} = imageStack{indexRef}; % one of the latent image remains the same     
idxPostRef = indexRef + 1;
idxPreRef = indexRef - 1;
keepRun = true;
%%

while keepRun
      if idxPreRef >= 1
         
         indexRef = idxPreRef + 1;
         idxSrc = idxPreRef;
         
         tempSrc   = imageStack{idxSrc};
         tempRef   = latentImgs{indexRef};
         [tempSrcPyr] = generatePyr(tempSrc);  % Generate the pyramid 
         [tempRefPyr] = generatePyr(tempRef);  % Generate the pyramid
         
         % Get the results
         [uv{idxSrc}, latentImgs{idxSrc}, intenMapFun{idxSrc}, invintenMapFun{idxSrc}] ...
                      = getlatentImages(tempSrcPyr,tempRefPyr);            
         idxPreRef = idxPreRef - 1;
      end           
      if idxPostRef <= numImages
         indexRef = idxPostRef - 1;
         idxSrc = idxPostRef;
         tempSrc    = imageStack{idxSrc};
         tempRef    = latentImgs{indexRef};            
         tempSrcPyr = generatePyr(tempSrc);
         tempRefPyr = generatePyr(tempRef);
         [uv{idxSrc}, latentImgs{idxSrc}, intenMapFun{idxSrc}, invintenMapFun{idxSrc}] ...
                       = getlatentImages(tempSrcPyr,tempRefPyr);        
         idxPostRef = idxPostRef + 1;
      end                                                                                                           
      if idxPreRef < 1 && idxPostRef > numImages
         keepRun = false;
      end
end 

%%
save([Datadir(index).name datestr(clock)  '.mat'], ...
        'uv', 'latentImgs', 'intenMapFun', 'invintenMapFun', 'imageStack');

%% 
% Display the results
figure;
subplot(1,2,1);
imshow(imageStack{1});
title('Original Image in Exposure Stack');
subplot(1,2,2);
imshow(latentImgs{1});
title('Image after aligning with the Referance Image');

figure;
subplot(1,2,1);
imshow(imageStack{2});
title('Original Image in Exposure Stack');
subplot(1,2,2);
imshow(latentImgs{2});
title('Image after aligning with the Referance Image');

figure;
subplot(1,2,1);
imshow(imageStack{3});
title('Original Image in Exposure Stack');
subplot(1,2,2);
imshow(latentImgs{3});
title('Image after aligning with the Referance Image');
