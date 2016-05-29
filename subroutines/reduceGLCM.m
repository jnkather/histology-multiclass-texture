% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file, includes disclaimer

function glcmsRed = reduceGLCM(glcms,numOffsets)
    glcmsRed = zeros(size(glcms,1),size(glcms,2),numOffsets);
    % reduce glcms to make it invariant wrt rotation
    numDirections = (size(glcms,3)/numOffsets);
    for i = 1:numOffsets
        idx = linspace(1,size(glcms,3)-numDirections,numDirections)+i-1;
        glcmsRed(:,:,i) = round(mean(glcms(:,:,idx),3));
    end
end