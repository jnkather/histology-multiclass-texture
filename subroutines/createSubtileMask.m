% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file in same folder, includes disclaimer

function subTileMask = createSubtileMask( cnst )

    %--- create mask --- 
    xsize = cnst.CoreBlockSize(1) + 2* cnst.BorderSize(1);
    ysize = cnst.CoreBlockSize(2) + 2* cnst.BorderSize(2);
    midX = round(xsize/2);
    midY = round(ysize/2);
    xlo = [1, midX+1, 1, midX+1]; 
    xhi = [midX, xsize, midX, xsize];
    ylo = [1, 1, midY+1, midY+1]; 
    yhi = [midY, midY, ysize, ysize];

    subTileMask = zeros(xsize,ysize);
    for s = 1:4
       subTileMask(xlo(s):xhi(s),ylo(s):yhi(s)) = s;
    end
    % ------------------

end

