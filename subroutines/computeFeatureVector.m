% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file in same folder, includes disclaimer

function featureVector = computeFeatureVector(imgIn, method, gaborArray)
    
    % convert image. imgIn should be uint8 RGB (no alpha), range 0 ... 255
    imgInGray = double(rgb2gray(imgIn))/255;
    
    % choose method
    switch lower(method)
 
    % pure feature sets     
    case 'histogram_higher', % higher order central moments of the histogram
        featureVector = histogramHigher(imgInGray);

    case 'histogram_lower', % lower order central moments of the histogram
        featureVector = histogramLower(imgInGray);

    case 'perceptual' % five features that mimick human texture perception
        featureVector = perceptualFeatures(imgInGray);

    case {'fourier-lbp','f-lbp'} % Local binary patterns, fourier variant
        featureVector = flbpFeatures(imgInGray);

    case 'glcmrotinv' % rotation invariant Gray-Level Co-Occurrence Matrix
        featureVector = glcmRotInvFeatures(imgInGray);

    case 'gaborrotinv' % rotation invariant Gabor filter response
        featureVector = gaborRotInvFeatures(imgInGray,gaborArray);
     
    % combinations of two or more methods    
    case 'best2' % best 2 feature sets  
        featureVector = [histogramLower(imgInGray),...
                         flbpFeatures(imgInGray)];

    case 'best3' % best 3 feature sets        
        featureVector = [histogramJoint(imgInGray),...
                         flbpFeatures(imgInGray)];

    case 'best4' % best 4 feature sets        
        featureVector = [histogramJoint(imgInGray),...
                         flbpFeatures(imgInGray),...
                         glcmRotInvFeatures(imgInGray)];
                     
    case 'best5' % best 5 feature sets         
        featureVector = [histogramJoint(imgInGray),...
                         flbpFeatures(imgInGray),...
                         glcmRotInvFeatures(imgInGray),...
                         perceptualFeatures(imgInGray)];                    

    case 'all6' % all feature sets            
        featureVector = [histogramJoint(imgInGray),...
                         flbpFeatures(imgInGray),...
                         glcmRotInvFeatures(imgInGray),...
                         perceptualFeatures(imgInGray),...
                         gaborRotInvFeatures(imgInGray,gaborArray)];    
    otherwise
        error('this method ist not available');
    end

end