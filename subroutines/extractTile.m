% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file, includes disclaimer

function imgThumb = extractTile( inputImg, saveDir, imgname, ...
        RC_locat, colorType,coreSize,BorderSize,saveProportion )
    
    % perform color preprocessing / channel reduction
    switch colorType
        case 'none' % do nothing
            1;
        case 'gray' % convert image to grayscale
            inputImg = rgb2gray(inputImg);
        otherwise
            error('invalid opt');
    end
    
    % check if image has full size (exclude smaller imgs and padded imgs)
    if size(inputImg,1) ~= coreSize(1)+BorderSize(1)*2 | ...
         size(inputImg,2) ~= coreSize(1)+BorderSize(1)*2 | ...    
            (min(sum(inputImg,1)) == 0) | ...
                (min(sum(inputImg,2) ) == 0)
        warning('image is too small (or padded with 0s), omitting');
        size(inputImg)
    else
        disp('image is valid... processing');
        if rand() <= saveProportion
        % save image
        randID = dec2hex(round(rand()*100000));
        imwrite(inputImg,[char(saveDir),'', randID,...
            '_',imgname,'_Row_',num2str(RC_locat(1)), '_Col_', ...
            num2str(RC_locat(2)), '.tif']);
        end
    end

    imgThumb = [];
end

