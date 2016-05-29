% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file, includes disclaimer

function showMyConfusionMatrix(ConfMat, currClassifierName, CatNames, saveDir)

    % create figure and show confusion matrix
    ax = figure();
    imagesc(ConfMat); % show confusion matrix as image
    colormap hot; axis square; colorbar; % color settings
    title(strrep(currClassifierName,'_',': '));
    
    % configure x and y axis
    xlabel('predicted class');          ylabel('true class'); 
    set(gca, 'XTickLabels', CatNames);  set(gca,'YTickLabels',CatNames);
    set(gca, 'XTickLabelRotation', 30); set(gca, 'YTickLabelRotation', 30); 
    set(gca, 'Ticklength', [0 0]);
    
    % save figure as PNG
    print(ax,'-dpng','-r600',[saveDir,currClassifierName,'-CONFUSION.png']);
    
end