function [F] = Roughness (I, G)
%Returns the roughness of a grey-scale image I
%
%INPUT
%I:         Grey-scale image
%G:         Number of grey levels
%OUTPUT:
%F:         Image roughness. Real number in [0,1].
%
%  Sample usage
%  --------
%       I=imread('rice.png');                           
%       imgInfo = imfinfo('rice.png');                  
%       bitDepth = imgInfo.BitDepth;                                                        
%       rg = Roughness(I, 2^bitDepth);

    %Normalise image
    I = double(I);
    I = I/(G-1);

    %Compute roughness
    F=std(I(:),1);
    F = 2*F;
end
