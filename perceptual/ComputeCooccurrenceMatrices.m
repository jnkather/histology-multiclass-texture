function CM = ComputeCooccurrenceMatrices(I, G, displacements, symmetrize);
%Computes grey-level co-occurrence matrices given a set of displacements.
%Filtering across borders is obtained through circular scan.
%
%INPUT
%I:             Grey-scale image      
%G:             Number of grey levels
%
%displacements: Displacements at which the co-occurrence matrices are
%                 computed (matrix of N x 2 integers)
%                   Example: d = [1 1] -> 1 pixel right / 1 pixel up
%                            d = [0 1] -> 0 pixel right / 1 pixel up
%                            d = [-1 0] -> 1 pixel left / 0 pixel up
%symmetrize:    'Y' makes the CM symmetric
%OUTPUT
%CM:            Stack of N co-occurrence matrices (3D matrix - G x G x N)
%
%  Sample usage
%  --------
%       I=imread('rice.png');                           
%       imgInfo = imfinfo('rice.png');                  
%       bitDepth = imgInfo.BitDepth;  
%       d = [0 1; 1 1];
%       symm = 'N';
%       CM = ComputeCooccurrenceMatrices(I, 2^bitDepth, d, symm);

% Version 0.1
% Authors: Francesco Bianconi

    [rows cols] = size(I);

    nDisplacements = size(displacements, 1);

    %Compute layers
    [L] = CreateImageLayers(I,displacements,'circular');
    
    %Convert to double (working with integers is troublesome)
    I = double(I);
    L = double(L);
    
    CM = zeros(G, G, nDisplacements);

    for d = 1:nDisplacements
        COOC = I.*G + L(:,:,d);
        H = histc(COOC(:),0:G^2-1)/(rows * cols);
        CM(:,:,d) = reshape(H,G,G);
    end


    %Symmetrize matrices if required
    if symmetrize == 'Y'
        for n = 1:nDisplacements
            CM(:,:,n) = (CM(:,:,n) + CM(:,:,n)')/2;
        end
    end

end
