% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file in same folder, includes disclaimer

function featureVector = perceptualFeatures(imgInGray)
    % ref.: F. Bianconi, A. ?lvarez-Larr?n, and A. Fern?ndez, ?Dis-
    % crimination between tumour epithelium and stroma via perception-
    % based features,? Neurocomputing, vol. 154, pp. 119?126, 2015.
    
    k = 4; nDiv = 12; d = 4;      % constants from Bianconi et al.
    imgGS = uint8(imgInGray)*255; % convert image to integer 0...255
    G = double(max(imgGS(:)));            % get max. intensity value 

    featureVector = [Coarseness(imgGS, G, k), ...
            Contrast(imgGS, G),...
            Directionality(imgGS, G, nDiv), ...
            LineLikeliness(imgGS, G, d, nDiv), ...
            Roughness(imgGS, G)]; % construct feature vector
end