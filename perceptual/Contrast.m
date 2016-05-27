function [F] = Contrast(I, G)
%Returns the contrast of a grey-scale image I
%
%INPUT
%I:         Grey-scale image
%G:         Number of grey levels
%OUTPUT:
%F:         Image contrast. Real number in [0,1].
%
%  Sample usage
%  --------
%       I=imread('rice.png');                           
%       imgInfo = imfinfo('rice.png');                  
%       bitDepth = imgInfo.BitDepth;                                                      
%       cn = Contrast(I, 2^bitDepth);

% Version 0.1
% Authors: Francesco Bianconi and Fernando Domínguez

    %Normalise image
    I=double(I);
    I=I/(G-1);

    %Compute mean and std
    sg=std(I(:),1);
    mu=mean(I(:));
    [m,n]=size(I);
    
    %Compute kurtosis
    alpha4 = kurtosis(I(:),1);

    %Compute contrast
    F= 2 * sg/((alpha4)^0.25);

end