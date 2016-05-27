% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file in same folder, includes disclaimer

function showOriginalClassifiedConfidence(imgResult,cnst,plotName,curr_impath,CatNames)
    
    % -------- PREPARE
    
    % find 3 most abundant classes
    predictions = imgResult(:,:,cnst.maxClass+2);
    foundClasses = unique(predictions);
    foundClasses(foundClasses == 0) = []; % remove 0 class
    count = 1;
    for i=(foundClasses'),scores(count) = sum(predictions(:) == i); count = count+1; end
    [y,idx] = sort(scores,'descend');
    idx = foundClasses(idx);
    
    % scale these classes for display
    trivariateVis = imgResult(:,:,idx(1:3));
    trivariateVis = normalizeImage(trivariateVis,'no-stretch');
    
    % -------- PLOT
    
    plot1 = 1; plot2 = 1; plot3 = 1; plot4 = 1; plot5 = 1; plot6 = 1;
    
    if plot1
    figure()
    
    % show original
    subplot(1,2,1);
    imshow(curr_impath);
    title('original image');
    
    % show trivariate visualization of most abundant classes
    subplot(1,2,2);
    if numel(idx)>=3
    imshow(trivariateVis);
    title(['Red = ', char(CatNames(idx(1))),10,...
          'Green = ', char(CatNames(idx(2))),10,...
          'Blue = ', char(CatNames(idx(3)))]);
    elseif numel(idx) == 2
            imshow(imgResult(:,:,idx(1:2)),[]);
            title(['Red = ', char(CatNames(idx(1))),10,...
                  'Green = ', char(CatNames(idx(2)))]);
    else
        error('fewer than 2 classes');
    end
       
    % add decorations and save
    set(gcf,'Color','w');
    suptitle(plotName); drawnow;
    print(gcf,'-dpng','-r600',[cnst.outputDir,plotName,'_composite','.png']);
    end
    
    % -----------------------------
    if plot2  
    figure()
    % show original
    subplot(1,2,1);
    imshow(curr_impath);
    title('original image');
    
    % --- 3rd plot: Decision
    subplot(1,2,2);
    
    [myCmap,CatNamesShort] = tissueColorMap(cnst.maxClass);
          
    highestClass = (imgResult(:,:,cnst.maxClass+2));   
    highestClassRGB = ind2rgb(highestClass,myCmap);
    
    downScImg = 50;
    highestClassRGBsmall = (imresize(highestClassRGB,1/downScImg));
     for ch = 1:size(highestClassRGBsmall,3)
         highestClassRGBsmall(:,:,ch) = medfilt2(highestClassRGBsmall(:,:,ch),[3,3]);
     end
     
    highestClassRGBreconstr = imresize(highestClassRGBsmall,downScImg,'bicubic');
    
%     figure(), subplot(1,2,1), imshow(highestClassRGB),
%     subplot(1,2,2), imshow(highestClassRGBreconstr)

    
    imshow(highestClass,[]);hold on;
    colormap(myCmap);   
    for j=1:cnst.maxClass, highestClass(j) = j; end % add calibration pixels
    imshow(highestClass,[]);
    colormap(myCmap); 
    lcolorbar(CatNamesShort,'Location','horizontal');
    title('decision');

    print(gcf,'-dpng','-r600',[cnst.outputDir,plotName,'_decision','.png']);
    imwrite(highestClassRGBreconstr,[cnst.outputDir,plotName,'_decision_only','.png']);
    end
    
    if plot3
    % 4th: show probabilities
    imgResult = imgResult - min(imgResult(:));
    figure()
    for i=1:cnst.maxClass
        subplot(3,3,i)
        imshow(imgResult(:,:,i),[]);
        colormap hot
        title(char(CatNames(i)))
        colorbar
    end
    set(gcf,'Color','w');
    drawnow
    print(gcf,'-dpng','-r600',[cnst.outputDir,plotName,'_probabilities','.png']);  
    end

    if plot4
    % SHOW MONTAGE
    myMontage = createMontage(imgResult);
    figure(), imshow(myMontage),
    title(['Tumor - Stroma - Lymphocyte - Montage of ',plotName]);
    set(gcf,'Color','w');
    drawnow
    imwrite(myMontage,[cnst.outputDir,plotName,'_trivariate_montage','.png']);  
    end
    
    if plot5
       % show confidence
       confidence = normalizeImage(imgResult(:,:,cnst.maxClass+1),'no-stretch');
       imwrite(confidence,[cnst.outputDir,plotName,'_confidence','.png']);  
    end

    if plot6
        % SHOW specified MONTAGE
        myMontage = (imgResult(:,:,[1,2,3]));
        myMontage = normalizeImage(myMontage,'no-stretch');
        figure(), imshow(myMontage),
        title(['Tumor - Stroma - Complex - Montage of ',plotName]);
        set(gcf,'Color','w');
        drawnow
        imwrite(myMontage,[cnst.outputDir,plotName,'_trivariate_specified_montage','.png']);  
    end
    
end
