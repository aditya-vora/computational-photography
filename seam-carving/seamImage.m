function seamimage = seamImage(E)
% Function computes the seam path through dynamic programming.
sz = size(E); % Get the size of the Energy map.

seamimage = zeros(sz(1),sz(2));
seamimage(1,:) = E(1,:);

for i=2:sz(1)
    for j=1:sz(2)
        % Boundary conditions
        if j-1<1
            seamimage(i,j)= E(i,j)+min([seamimage(i-1,j),seamimage(i-1,j+1)]);
        elseif j+1>sz(2)
            seamimage(i,j)= E(i,j)+min([seamimage(i-1,j-1),seamimage(i-1,j)]);
        else
            seamimage(i,j)= E(i,j)+min([seamimage(i-1,j-1),seamimage(i-1,j),seamimage(i-1,j+1)]);
        end
    end
end
