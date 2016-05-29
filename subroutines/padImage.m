% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file, includes disclaimer

function imgOut = padImage( imgIn,finalSize,opt )
% this functions pads and reduces an RGB input image. Reduction can be
% achieved through PCA (convert image to 1st principle component) or gray
% (convert RGB to grayscale)

    imgIn = double(imgIn)/255;
    imgSize=size(imgIn); %#img is your image matrix

    switch opt % how to reduce
        case 'PCA' % convert image to 1st PC of image
            cut_dat = reshape(imgIn,[],3);

            [coeff,score,latent,tsquared,explained,mu] = pca(cut_dat);

            imgIn = reshape(score,imgSize(1),imgSize(2),3);

            imgOut = double(ones(finalSize,finalSize,3));
            imgOut(finalSize/2+(1:imgSize(1))-floor(imgSize(1)/2),...
               finalSize/2+(1:imgSize(2))-floor(imgSize(2)/2),:) = ...
               normalizeImage(imgIn,'no-stretch');
           imgOut = imgOut(:,:,1); % 1st PC only
       
        case 'gray' % convert image to grayscale
        imgOut = double(ones(finalSize,finalSize));
        imgOut(finalSize/2+(1:imgSize(1))-floor(imgSize(1)/2),...
           finalSize/2+(1:imgSize(2))-floor(imgSize(2)/2)) = ...
           normalizeImage(rgb2gray(imgIn),'no-stretch');    
            
        otherwise
            error('opt not implemented');
    end
    
   
end

