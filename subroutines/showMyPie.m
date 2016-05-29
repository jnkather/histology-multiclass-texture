% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file, includes disclaimer

function showMyPie(myLabelCats,CatNames,savepath)
    sums = sum(myLabelCats');
    figure();
    for i = 1:numel(CatNames)
        newLabel{i} = [char(CatNames{i}),10,'N=',num2str(sums(i)),''];
    end
    pie(sums,newLabel); % show pie chart, then plot decorations and save file
    set(gcf,'Color','w');   
    print(gcf,'-dpng','-r600',savepath);
end