% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file in same folder, includes disclaimer

function imageOut = normalizeImage(imageIn, opt)

    % convert image to double
	imageOut = double(imageIn);

    % process each channel
	for i=1:size(imageIn,3)

        % extract one channel at a time
		Ch = imageOut(:,:,i);

        % normalize output range to 0...1
		imageOut(:,:,i) = (imageOut(:,:,i)-min(Ch(:)))/(max(Ch(:)-min(Ch(:))));

        % optional: stretch histogram
        if strcmp(opt,'stretch')
        	imageOut(:,:,i) = imadjust(imageOut(:,:,i), ...
						stretchlim(imageOut(:,:,i)),[]);
						 % default option for stretchlim is [0.01,0.99]
        end
	end

end
