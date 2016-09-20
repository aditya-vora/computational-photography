function seam = backTrack(x)
% Function returns the seam Vector that contains the locations of the 
% Energy map that has minimum energy path. Basically it backtracks the
% the path that the seamImage function followed to compute the 
% seam and stores the locations with minimum energy.
[rows,cols] = size(x);
for i=rows:-1:1
    if i==rows
        % minimum element of the last row contains the cummulative 
        % energy measure.
        [~,j]=min(x(rows,:));  %finds min value of last row
    else %accounts for boundary issues
        if seam(i+1)==1
            vec=[Inf x(i,seam(i+1)) x(i,seam(i+1)+1)];
        elseif seam(i+1)==cols
            vec=[x(i,seam(i+1)-1) x(i,seam(i+1)) Inf];
        else
            vec=[x(i,seam(i+1)-1) x(i,seam(i+1)) x(i,seam(i+1)+1)];
        end
        
        %find min value and index of 3 neighboring pixels in prev. row.
        [~,Inx]=min(vec);
        IndexInc=Inx-2;
        j=seam(i+1)+IndexInc;
    end
    seam(i,1) = j;
end

end

