function [NNF, debug] = patchmatch(targetImg, sourceImg, psz)
% Function computes the patchmatch between two images
% PARAMETERS:
% NNF = Nearest Neighbour Field
% targetImg = Target Image
% sourceImg = Source Image
% psz = Patch Size
%%
% set patchsize to default
if (nargin<3) 
    psz = 9; 
end

% grayscale images only (TODO: extend to color images)
if ~ismatrix(targetImg) 
    targetImg = rgb2gray(targetImg); 
end
if ~ismatrix(sourceImg) 
    sourceImg = rgb2gray(sourceImg); 
end

targetImg = double(targetImg);
sourceImg = double(sourceImg);

%% Parameters
max_iterations = 4;
srcsize = [size(sourceImg,1),size(sourceImg,2)];
targetsize = [size(targetImg,1),size(targetImg,2)];
radius = srcsize(1)/4;
alpha = .5;
Radius = round(radius*alpha.^(0:(-floor(log(radius)/log(alpha)))));
lenRad = length(Radius);
% Only valid patch sizes are odd.
if mod(psz,2)==1
    w = (psz-1)/2;
else
    error('psz must be odd.');
end

targetImg_NaN = nan(targetsize(1)+2*w,targetsize(2)+2*w);
targetImg_NaN(1+w:targetsize(1)+w,1+w:targetsize(2)+w) = targetImg;

% NNF indices whose patches do not lap over outer range of images
NNF = cat(3,...
    randi([1+w,srcsize(1)-w],targetsize),...
    randi([1+w,srcsize(2)-w],targetsize)...
);
offsets = inf(targetsize(1),targetsize(2));
for ii = 1:targetsize(1)
    for jj = 1:targetsize(2)
        ofs_ini = targetImg_NaN(w+ii-w:w+ii+w,w+jj-w:w+jj+w)...
          -     sourceImg(NNF(ii,jj,1)-w:NNF(ii,jj,1)+w,NNF(ii,jj,2)-w:NNF(ii,jj,2)+w);
        ofs_ini = ofs_ini(~isnan(ofs_ini(:)));
        offsets(ii,jj) = sum(ofs_ini.^2)/length(ofs_ini);
    end
end
debug.offsets_ini = offsets;
debug.NNF_ini = NNF;
for iteration = 1:max_iterations
is_odd = mod(iteration,2)==1;
%% raster scan or reverse raster scan
if is_odd % odd
     ii_seq = 1:targetsize(1); jj_seq = 1:targetsize(2);
else % even
    ii_seq = targetsize(1):(-1):1; jj_seq = targetsize(2):(-1):1;
end
% dispProgress = false(targetsize(1)*targetsize(2),1);
% dispInterval = floor(targetsize(1)*targetsize(2)/10);
% dispProgress(dispInterval:dispInterval:end) = true;
% debug.dispProgress = dispProgress;

for ii = ii_seq
  for jj = jj_seq
    if is_odd %odd
        ofs_prp(1) = offsets(ii,jj);
        ofs_prp(2) = offsets(max(1,ii-1),jj);
        ofs_prp(3) = offsets(ii,max(1,jj-1));
        [~,idx] = min(ofs_prp);
        switch idx
        case 2
            if NNF(ii-1,jj,1)+1+w<=srcsize(1) && NNF(ii-1,jj,2)+w<=srcsize(2)
                NNF(ii,jj,:) = NNF(ii-1,jj,:);
                NNF(ii,jj,1) = NNF(ii,jj,1)+1;
                tmp = targetImg_NaN(w+ii-w:w+ii+w,w+jj-w:w+jj+w)...
                      - sourceImg(NNF(ii,jj,1)-w:NNF(ii,jj,1)+w,NNF(ii,jj,2)-w:NNF(ii,jj,2)+w);
                tmp = tmp(~isnan(tmp(:)));
                offsets(ii,jj) = sum(tmp(:).^2)/length(tmp(:));
            end

        case 3
            if NNF(ii,jj-1,1)<=srcsize(1) && NNF(ii,jj-1,2)+1+w<=srcsize(2)
                NNF(ii,jj,:) = NNF(ii,jj-1,:);
                NNF(ii,jj,2) = NNF(ii,jj,2)+1;
                tmp = targetImg_NaN(w+ii-w:w+ii+w,w+jj-w:w+jj+w)...
                      - sourceImg(NNF(ii,jj,1)-w:NNF(ii,jj,1)+w,NNF(ii,jj,2)-w:NNF(ii,jj,2)+w);
                tmp = tmp(~isnan(tmp(:)));
                offsets(ii,jj) = sum(tmp(:).^2)/length(tmp(:));
            end
        end
    else %even
        % center, bottom, right
        ofs_prp(1) = offsets(ii,jj);
        ofs_prp(2) = offsets(min(ii+1,targetsize(1)),jj);
        ofs_prp(3) = offsets(ii,min(jj+1,targetsize(2)));
        [~,idx] = min(ofs_prp);

        % propagate from bottom
        switch idx
        case 2
            if idx==2 && NNF(ii+1,jj,1)-1-w>=1 && NNF(ii+1,jj,2)-w>=1
                NNF(ii,jj,:) = NNF(ii+1,jj,:);
                NNF(ii,jj,1) = NNF(ii,jj,1)-1;
                tmp = targetImg_NaN(w+ii-w:w+ii+w,w+jj-w:w+jj+w)...
                      - sourceImg(NNF(ii,jj,1)-w:NNF(ii,jj,1)+w,NNF(ii,jj,2)-w:NNF(ii,jj,2)+w);
                tmp = tmp(~isnan(tmp(:)));
                offsets(ii,jj) = sum(tmp(:).^2)/length(tmp(:));
            end

            % propagate from right
        case 3
            if idx==3 && NNF(ii,jj+1,1)-w>=1 && NNF(ii,jj+1,2)-1-w>=1
            % elseif idx==3 && NNF(ii,jj+1,1)-w>=1 && NNF(ii,jj+1,2)-1-w>=1
                NNF(ii,jj,:) = NNF(ii,jj+1,:);
                NNF(ii,jj,2) = NNF(ii,jj,2)-1;
                tmp = targetImg_NaN(w+ii-w:w+ii+w,w+jj-w:w+jj+w)...
                      - sourceImg(NNF(ii,jj,1)-w:NNF(ii,jj,1)+w,NNF(ii,jj,2)-w:NNF(ii,jj,2)+w);
                tmp = tmp(~isnan(tmp(:)));
                offsets(ii,jj) = sum(tmp(:).^2)/length(tmp(:));
            end
        end

    end
    iis_min = max(1+w,NNF(ii,jj,1)-Radius(:));
    iis_max = min(NNF(ii,jj,1)+Radius(:),srcsize(1)-w);
    jjs_min = max(1+w,NNF(ii,jj,2)-Radius(:));
    jjs_max = min(NNF(ii,jj,2)+Radius(:),srcsize(2)-w);

    iis = floor(rand(lenRad,1).*(iis_max(:)-iis_min(:)+1)) + iis_min(:);
    jjs = floor(rand(lenRad,1).*(jjs_max(:)-jjs_min(:)+1)) + jjs_min(:);

    nns(:,1) = NNF(ii,jj,:);
    nns(:,2:lenRad+1) = [iis';jjs'];

    ofs_rs(1) = offsets(ii,jj);
    for itr_rs = 1:lenRad
        tmp1 = targetImg_NaN(w+ii-w:w+ii+w,w+jj-w:w+jj+w) - sourceImg(iis(itr_rs)-w:iis(itr_rs)+w,jjs(itr_rs)-w:jjs(itr_rs)+w);
        tmp2 = tmp1(~isnan(tmp1(:)));
        ofs_rs(itr_rs+1) = sum(tmp2.^2)/length(tmp2);
    end

    [~,idx] = min(ofs_rs);
    offsets(ii,jj) = ofs_rs(idx);
    NNF(ii,jj,:) = nns(:,idx);

    %if dispProgress((ii-1)*targetsize(2)+jj); fprintf('='); end

  end % jj
end % ii

end % iteration

debug.offsets = offsets;

end % end of function
