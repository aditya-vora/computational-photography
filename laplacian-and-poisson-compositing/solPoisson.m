function destination = solPoisson(source,Fh,Fv,mask,itr)
% Used to select the boundary region
Kernal=[0,1,0;1,0,1;0,1,0];
% Region of image with mask is not zero
reg = ( mask > 0 );
% Make laplacian from the gradient
laplacian = grad2lap(Fh,Fv);
destination = source;
for i = 1:itr
% filter with the assigned kernel to detect theee boundary pixels
 lpf = imfilter(destination,Kernal,'replicate');
% take the central difference
 destination(reg) = (laplacian(reg) + lpf(reg))/4;
end
end

function lap = grad2lap(Fh, Fv)
    lap = circshift(Fh,[0,1]) + circshift(Fv,[1,0]) - Fh - Fv;
end