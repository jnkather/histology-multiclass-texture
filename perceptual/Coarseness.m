function [F] = Coarseness(I,G,k)
%Returns the coarseness of a grey-scale image
%
%INPUT
%I:         Grey-scale image
%k:         Size parameter: defines the size of the filters applied to the
%           input image. 
%G:         Number of grey levels
%OUTPUT:
%F:         Image coarseness. Real number in [0,1].
%
%  Sample usage
%  --------
%       I=imread('rice.png');                           
%       imgInfo = imfinfo('rice.png');                  
%       bitDepth = imgInfo.BitDepth;                    
%       k = 3; %Coarseness computed using three square windows of 
%              %size 2^1 x 2^1, 2^2 x 2^2 and 2^3 x 2^3                                     
%       cr = Coarseness(I, 2^bitDepth, k);

% Version 0.1
% Authors: Francesco Bianconi and Fernando Domínguez

    %Normalise image
    I=double(I);
    I=I/(G-1);
    
    C=Step1(I,k);
    [Eh,Ev]=Step2(C);
    S=Step3(Eh,Ev,k);
    [F]=Step4(S,k);
end

function [A]= Step1 (I,K)
%First step: apply a set of mean filters. Each filter is defined by 
%a square window of dimension 2 k × 2 k

    [m,n]=size(I);
    A=zeros(m,n,K);
    
    for k=1:K
    
        h=fspecial('average',[2^k 2^k]);
        A(:,:,k)=imfilter(I,h,'circular');
    
    end

end

function [Eh, Ev]= Step2 (I)
%Second step: apply a vertical and a horizontal difference mask which assign, 
%to each pixel, the difference between the values of the two symmetric
%pixels that lie vertically or horizontally at distance 2^(k?1) from the given one

    [m n K] = size(I);
    S = [I I I; I I I; I I I];
    Eh = zeros(m,n,K);
    Ev = zeros(m,n,K);
    
    for k=1:K
        Ah1 = S(m+1 + 2^(k-1):2*m + 2^(k-1), n+1: 2*n, k);
        Ah2 = S(m+1 - 2^(k-1):2*m - 2^(k-1), n+1: 2*n, k);
        Eh(:,:,k) = abs(Ah1-Ah2);
        Av1 = S(m+1:2*m,n+1 + 2^(k-1):2*n + 2^(k-1), k);
        Av2 = S(m+1:2*m,n+1 - 2^(k-1):2*n - 2^(k-1), k);
        Ev(:,:,k) = abs(Av1-Av2);
    end
end

function [S] = Step3 (Eh,Ev,K)
%Third step: take as coarseness the average windows size that in each point 
%maximises the value of E(x,y) in either directions

    [m,n,l]= size(Eh);
    S=zeros(m,n);

    
    E=cat(3,Eh,Ev);
    [maxValues, indices] = max(E,[],3);
    indices = mod(indices,K);
    indices(indices == 0) = K;
    S=2.^indices;
end

function [F] = Step4 (S,K)
%Fourth step: compute the average value and normalise 

    F=mean2(S);
    F=F/(2^K);

end