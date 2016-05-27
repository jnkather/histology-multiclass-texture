% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file in same folder, includes disclaimer

function featureVector = glcmRotInvFeatures(imgInGray)

    % ref.: R. Haralick, K. Shanmugan, and I. Dinstein, ?Textural 
    % features for image classification,? IEEE Transactions on Systems, 
    % Man and Cybernetics, vol. 3. pp. 610?621, 1973.

    offsets = getMyGLCMParams();   % get offset matrix
    glcms = graycomatrix(imgInGray,'Offset',offsets,'Symmetric',true);
    glcms_red = reduceGLCM(glcms,5); % 5 offset values, 4 directions
    stats = graycoprops(glcms_red,{'Contrast','Correlation','Energy','Homogeneity'});
    featureVector = [stats.Contrast, stats.Correlation, stats.Energy, stats.Homogeneity];
end