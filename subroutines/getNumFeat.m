% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file in same folder, includes disclaimer

function numFeatures = getNumFeat(featureType)

    switch lower(featureType)
        case {'fourier-lbp','f-lbp'}, numFeatures = 38; 
        case 'perceptual',            numFeatures = 5; 
        case 'histogram_higher',      numFeatures = 10;        
        case 'histogram_lower',       numFeatures = 5;     
        case 'glcmrotinv',            numFeatures = 20;   
        case 'gaborrotinv',           numFeatures = 6;

        case 'best2',        numFeatures = 5+38;
        case 'best3',        numFeatures = 5+38+6;
        case 'best4',        numFeatures = 5+38+6+20;
        case 'best5',        numFeatures = 5+38+6+20+5;
        case 'all6',         numFeatures = 5+38+6+20+5+6;
    end
    
end
