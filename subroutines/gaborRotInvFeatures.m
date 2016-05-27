% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file in same folder, includes disclaimer

function featureVector = gaborRotInvFeatures(imgInGray,gaborArray)
    gaborMag = imgaborfilt(imgInGray,gaborArray);
    featureVector_long = mean(reshape(gaborMag,[], size(gaborMag,3)));
    featureVector = reduceGabor(featureVector_long,6); %  6 offsets
end
