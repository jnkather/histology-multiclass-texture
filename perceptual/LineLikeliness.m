function F = LineLikeliness(I, G, d, nBins)
%Returns the line-likeliness of a grey-scale image I
%
%INPUT
%I:         Grey-scale image
%G:         Number of grey levels
%d:         Distance at which line-likeliness is computed
%nBins:     Number of bins into which the histogram of gradient
%           directions is quantised
%
%OUTPUT
%F:         Image line-likeliness.
%
%  Sample usage
%  --------
%       I=imread('rice.png');                           
%       imgInfo = imfinfo('rice.png');                  
%       bitDepth = imgInfo.BitDepth;                    
%       nBins = 10;
%       d = 4;
%       nBins = 10;
%       ll = LineLikeliness(I, 2^bitDepth, d, nBins);

% Version 0.1
% Authors: Francesco Bianconi and Fernando Domínguez

    %Normalise the input image
    I = double(I);
    I = I/(G-1);

    %Compute the image gradient
    [G,a] = Gradient(I, '2pi');
    
    %Quantise the gradient orientation
    [a] = uint8(round(((nBins -1) * mat2gray(a,[-pi pi]))));
    
    %Define the displacements
    D = [0 d; -d d; -d 0; -d -d];
    nDisp = size(D,1);
    
    %Compute the co-occurrence matrices
    CM = ComputeCooccurrenceMatrices(a, nBins, D, 'Y');
    
    
    %Define weights
    W = zeros(nBins);
    for i = 0:nBins-1
        for j = 0:nBins-1
            W(i+1,j+1) = abs(cos((i - j) * 2 * pi/nBins));
        end
    end
    
    %Apply weights
    F = zeros(1,nDisp);
    for d = 1:nDisp
        CM(:,:,d) = CM(:,:,d).*W;
        
        %Compute like-lineliness
        F(d) = sum(sum(CM(:,:,d)));
    end

    F = mean(F);
    
end