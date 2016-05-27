% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file in same folder, includes disclaimer

function [decision, confidence] = computeConfidence( committeeVotes )

    decision = find(committeeVotes==max(committeeVotes));

    others = committeeVotes;
    others(committeeVotes==max(committeeVotes)) = [];
    confidence = max(committeeVotes)/mean(others);
    
end

