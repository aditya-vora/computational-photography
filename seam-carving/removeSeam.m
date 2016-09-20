function x=removeSeam(x,Seam)
[rX, cX, dim] = size(x); % get the dimension of the image
[Sr, Sc, ~] = size(Seam); % get the size of the seam

if rX~=Sr
        error('SeamVector and image dimension mismatch');
end
%ReduceImage = zeros(size(x));
if (rX == Sr)
    for k=1:Sc              %goes through set of seams
        for i=1:dim             %if rgb, goes through each channel
            for j=1:rX        %goes through each row in image
                if Seam(j,k)==1
                    ReduceImage(j,:,i)= x(j,2:cX,i);
                elseif Seam(j,k)==cX
                    ReduceImage(j,:,i)= x(j,1:cX-1,i);
                else
                    ReduceImage(j,:,i)=[x(j,1:Seam(j,k)-1,i) x(j,Seam(j,k)+1:cX,i)];
                end
            end
        end
        x=ReduceImage;
        clear ReduceImage
        [rX, cX, dim]=size(x);
    end
end