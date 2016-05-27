function [L] = CreateImageLayers(I,displacements,boundaryOptions)
%Distribute the input image I among a stack of layers each representing a 
%translated copy of I 
%
%INPUT
%I:                 a grey-scale image 
%displacements:     a D x 2 vector respresenting a set of displacements
%boundaryOptions:   how to cope with edge effects (when the displacement
%                   goes across the image borders). Can be:
%                       'circular'
%                       'symmetric'                       
%                   - see imfilter() - 
%
%OUTPUT
%L:                 an R x C x D matrix, where R and C are the dimensions
%                   of the input image
%
%  Sample usage
%  --------
%       I=imread('rice.png');                           
%       d = [0 1; 1 1];
%       bopt = 'circular';
%       L = CreateImageLayers(I, d, bopt);

    [rows cols] = size(I);
    D = size(displacements,1);
    
    if isa(I,'uint8')
        L = uint8(zeros(rows,cols,D));
    elseif isa(I,'uint16')
        L = uint16(zeros(rows,cols,D));
    elseif isa(I,'uint32')
        L = uint32(zeros(rows,cols,D));
    elseif isa(I,'uint64')
        L = uint64(zeros(rows,cols,D));
    elseif isa(I,'double')
        L = zeros(rows,cols,D);
    else
        error('Unsupported type');
    end

    switch boundaryOptions
        case 'circular'
            I = [I I I; I I I; I I I];
        case 'symmetric'
            I = [flipud(fliplr(I)) flipud(I) flipud(fliplr(I));...
                 fliplr(I) I fliplr(I);...
                 flipud(fliplr(I)) flipud(I) flipud(fliplr(I))];
        otherwise 
            error('Unsupported boundary option');
    end

    %Origin
    x0 = rows + 1;
    y0 = cols + 1;
    
    %Create the layers
    for d = 1:D
        xStart = x0 - displacements(d,1);
        yStart = y0 - displacements(d,2);
        xEnd = xStart + rows - 1;
        yEnd = yStart + cols - 1;
        L(:,:,d) = I(xStart:xEnd,yStart:yEnd);
    end
        
end