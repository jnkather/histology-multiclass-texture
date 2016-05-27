function featureVector = flbpFeatures(imgInGray)
        % ref.: T. Ahonen, J. Matas, C. He, and M. Pietik?inen, 
        % ?Rotation Invariant Image Description with Local Binary 
        % Pattern Histogram Fourier Features,? Scia, pp. 61?70, 2009.
        % see http://www.cse.oulu.fi/CMV/Downloads/LBPMatlab
        
        % input: grayscale image, values 0...1 (double precision floats)
        mapping=getmaplbphf(8);            % constants from Ahonen et al.
        h=lbp(imgInGray,1,8,mapping,'h');  % compute LBP
        h=h/sum(h);                        % normalize LBP
        histograms(1,:)=h;                 % create LBP histogram
        featureVector =constructhf(histograms,mapping); % reduce dimensions
        
end