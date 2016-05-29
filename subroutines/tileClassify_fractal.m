% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file, includes disclaimer

function out = tileClassify_fractal(imgIn,myClassifier,...
    numFeats,numClasses,featType,cnst,setStats)

    % compute features, then apply classifier to features
    featureVector = computeFeatureVector(imgIn,featType,[]);
    
    [label,committeeVotes] = predict(myClassifier,featureVector(:)');
    
    % save the vote for each class to the respective channel in "out"
    out = double(zeros(size(imgIn,1),size(imgIn,2),numClasses+2));
    for i=1:numClasses, out(:,:,i) = committeeVotes(i); end
    
    % check confidence and compute decision and write to separate channels
    [decision, confidence] = computeConfidence(normalizeVector(committeeVotes));
    try
        out(:,:,numClasses+1) = confidence;
        out(:,:,numClasses+2) = decision;
    catch % in case of error, occurs when feature vector contains NaNs
        out(:,:,numClasses+1) = 0;  % set confidence to zero
        out(:,:,numClasses+2) = 9;  % set decision to background
        warning('set confidence to zero and decision to background (9)');
    end
    
    % check if confidence is high enough
    if confidence < cnst.confidenceThresh(1)
       
       fracLevel = 2;
       if fracLevel <= cnst.maxFractal
       disp(['entering fractal level ', num2str(fracLevel)]);
       % re-compute the current tile. lesson learned: it does not work to
       % call blockproc from within blockproc because this gives a java
       % error. So, tiling has to be done manually
      
       % split tile again and compute features
       for s = 1:numel(unique(cnst.subTileMask(:)))

           [r,c] = find(cnst.subTileMask==s);
           clear others committeeVotes
  
           % compute features, then apply neural network to features
           featureVector = computeFeatureVector(...
               imgIn(min(r):max(r),min(c):max(c),:),numFeats,featType, setStats,cnst.offsets);
           [label,committeeVotes] = predict(myClassifier,featureVector(:)');
           
           % write votes to output matrix
           	for i=1:numClasses
                out(min(r):max(r),min(c):max(c),i) = committeeVotes(i);
            end
            
            % check confidence and write to last channel
            [decision, confidence] = computeConfidence(normalizeVector(committeeVotes));
            
            if confidence < cnst.confidenceThresh(2)
                % if confidence does not exceed threshold, set all votes to 0
                out(min(r):max(r),min(c):max(c),1:numClasses) = 0;
                % ... and set decision to 0
                decision = 0;
            end
            
            % write confidence and decision to array
            out(min(r):max(r),min(c):max(c),numClasses+1) = confidence;
            out(min(r):max(r),min(c):max(c),numClasses+2) = decision;
            disp(['completed fractal tile, decision ', num2str(decision)]);

       end
       end 
    end
end
