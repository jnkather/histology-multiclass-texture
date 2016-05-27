% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file in same folder, includes disclaimer

function imgShow = createMontage(imgResult)

imgShow = normalizeImage(imgResult(:,:,[1,2,3]),'no-stretch');

minVal = min(imgShow(:));

imgShow = imgShow - 2 * imgResult(:,:,[8,8,8]) ...
                  - 2 * imgResult(:,:,[7,7,7]) ...
                  - 2 * imgResult(:,:,[5,5,5]) ...
                  - 2 * imgResult(:,:,[6,6,6]);

imgShow(imgShow<0) = minVal;

imgShow = normalizeImage(imgShow,'stretch');

end