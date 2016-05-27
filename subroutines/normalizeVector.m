% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file in same folder, includes disclaimer

function vec = normalizeVector(vec)
    vec = (vec - min(vec));
    vec = vec / max(vec);
end

