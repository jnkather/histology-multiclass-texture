% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file in same folder, includes disclaimer

function featureVector = histogramHigher(imgInGray)
        % input: grayscale image, values 0...1 (double precision floats)
        % histogram-based features: higher-order central moments (moment 2 ... n)
        numFeatures = 10;
        featureVector = zeros(1,numFeatures);  % preallocate
        for i=1:numFeatures, featureVector(i) = moment(imgInGray(:),i+1); end   
end