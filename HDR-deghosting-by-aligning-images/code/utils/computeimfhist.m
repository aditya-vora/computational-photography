function [ ppIMF ] = computeimfhist( srcImg, refImg, viz )
%% 
% Function computes the histogram of Intensity Mapping Fucntion 
% PARAMETERS:
% ppIMF = Intensity Mapping Function
% srcImg = Source Image
% refImg = Referance Image

%%
if ~exist('viz', 'var')
    viz = false;
end

nChannel = size(srcImg,3);
bins     = 0:1/255:1;

for iCh = 1:nChannel
    
    srcSubCh = srcImg(:,:,iCh);
    refSubCh = refImg(:,:,iCh);
    
    srcCul = cumsum(histc(srcSubCh(:), bins));
    refCul = cumsum(histc(refSubCh(:), bins));
     
    srcSample = samplecul(srcCul);
    refSample = samplecul(refCul);
    
    x = bins(srcSample);
    y = bins(refSample); 
    ex      = [x(1:end), x(end-1)];
    inds    = (ex(1:end-1) ~= ex(2:end));        
    xSample = x(inds);
    ySample = y(inds);
    xSample = [-.1, xSample(:)', 1.1];    
    ySample = [-.1, ySample(:)', 1.1];
    
    ppIMF{iCh} = pchip(xSample, ySample);
    if viz
        scatterHist = [refSubCh(:),srcSubCh(:)];
        figure, imagesc( log(1 + hist3(scatterHist,{bins, bins})) );
        axis xy;
        hold on; plot(255*(0:.01:1), 255 * ppval(ppIMF{iCh},0:.01:1));
    end
    
end
end
%%
function sample = samplecul(cul, nSample)

if ~exist('nSample', 'var')
    nSample = 50;
end

sample  = zeros(nSample-1,1);
iSample = 1;
ratio   = 1/nSample;
nTotal  = cul(end,1);

for i = 1 : size(cul,1)
    count = cul(i);
    while count > nTotal * ratio && count <= nTotal
        sample(iSample) = i;
        iSample         = iSample + 1;
        ratio           = ratio + 1/nSample;
    end           
end

for i = iSample : nSample-1
    sample(i) = sample(i-1);
end

end
