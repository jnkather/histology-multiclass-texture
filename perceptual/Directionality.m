function [F] = Directionality (I, G, nBins)
%Returns the directionality of a grey-scale image I
%
%INPUT
%I:         Grey-scale image
%G:         Number of grey levels
%nBins:     Number of bins into which the histogram of gradient
%           directions is quantised
%OUTPUT:
%F:         Image directionality. Real number in [0,1].
%
%  Sample usage
%  --------
%       I=imread('rice.png');                           
%       imgInfo = imfinfo('rice.png');                  
%       bitDepth = imgInfo.BitDepth;                    
%       nBins = 10;                                     
%       dr = Directionality (I, 2^bitDepth, nBins);

% Version 0.1
% Authors: Francesco Bianconi and Fernando Domínguez

    %Normalise image
    I = double(I);
    I = I/(G-1);
    
    %Compute gradient
    [G,a]=Gradient(I, 'pi');
    
    %Compute histogram of gradient directions
    [H]=Step3(a,nBins);
    [F]=Step4(H,nBins);
    
end


function [H] = Step3 (a,nBins)
%Compute histogram of gradient directions

    [m,n] = size(a);
    delta = pi/nBins;

    %Create histogram edges
    edges = -pi/2 + (0:nBins-1).*delta;
    edges = [edges, (1.1)*pi/2];            %Trick
    
    Vector = reshape(a,1,m*n);
    numNaN = sum(isnan(Vector));
    if(numNaN == m*n)
        H=0;
    else
        H = histc(Vector,edges)/(m*n-numNaN);
        H(end)=[];
        edges(end)=[];
%         figure;
%         bar(edges,H);
    end
    
end

function [F] = Step4 (H,nBins)
%Compute directionality
    
    %Uniform distribution
    U = (1/nBins)*ones(1,nBins);
    
    %Distance from U
    F = sqrt(sum((H - U).^2));
    
    %Max distance
    dMax = sqrt((nBins - 1)/nBins);
    
    %Normalise
    F = F/dMax;

    %F = std(H(:),1);
    
%     %Compute entropy
%     F = sum(-H.*log2(H));
%         
%     
%     %Normalize by dividing by the maximum attainable entropy
%     F = (1/log2(nBins))*F;
    

end
