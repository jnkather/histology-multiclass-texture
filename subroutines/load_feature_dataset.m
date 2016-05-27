% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file in same folder, includes disclaimer

function [CatNames, myFullData, myData, myLabels, myLabelCats, setStats] = ...
    load_feature_dataset(setName, setVersion, varargin)
% arguments:
% setName can be 'moments' or 'f-lbp' or 'tamura'
% varargin{1} can be 'merge' to merge low grade and high grade tumor
% varargin{2} selects the highest class to use (>2)
% varargin{3} selects the proportion of the dataset to use, 0<=x<=1

%% load data
% load previously saved feature matrix and label vector
switch lower(setName) % check which set was requested
    
% --------------------------------------------------------------------
 case {'fourier-lbp','f-lbp'},  switch upper(setVersion)
   case 'PRIMARY'
     setFile = 'PRIMARY/f-lbp_numFeatures38_last_output_rand_99638.2229.mat';
   case 'MET', 
     setFile = 'MET/';          end      

% --------------------------------------------------------------------
 case 'perceptual',             switch upper(setVersion)
   case 'PRIMARY'
     setFile = 'PRIMARY/perceptual_numFeatures5_last_output_rand_46579.mat';
   case 'MET', 
     setFile = 'MET/';          end     
                                             
% --------------------------------------------------------------------
 case 'histogram_higher',       switch upper(setVersion)
   case 'PRIMARY'
     setFile = 'PRIMARY/histogram_higher_numFeatures10_last_output_rand_26757.3086.mat';
   case 'MET', 
     setFile = 'MET/';          end       
                                             
% --------------------------------------------------------------------   
 case 'histogram_lower',        switch upper(setVersion)
   case 'PRIMARY'
     setFile = 'PRIMARY/histogram_lower_numFeatures5_last_output_rand_17203.mat';
   case 'MET', 
     setFile = 'MET/';          end          
                                             

% --------------------------------------------------------------------    
 case {'glcm','glcmrotinv'},    switch upper(setVersion)
   case 'PRIMARY'
     setFile = 'PRIMARY/glcmRotInv_numFeatures20_last_output_rand_42757.mat';
   case 'MET', 
     setFile = 'MET/';          end               

% --------------------------------------------------------------------    
 case {'gabor','gaborrotinv'},  switch upper(setVersion)
   case 'PRIMARY'
     setFile = 'PRIMARY/GaborRotInv_numFeatures6_last_output_rand_26339.mat';
   case 'MET', 
     setFile = 'MET/';          end    
                                             
% --------------------------------------------------------------------   
 case 'best2',                  switch upper(setVersion)
   case 'PRIMARY'
     setFile = 'PRIMARY/best2_numFeatures43_last_output_rand_18053.mat';
   case 'MET', 
     setFile = 'MET/';          end     
% --------------------------------------------------------------------   
 case 'best3',                  switch upper(setVersion)
   case 'PRIMARY'
     setFile = 'PRIMARY/best3_numFeatures49_last_output_rand_67445.mat';
   case 'MET', 
     setFile = 'MET/';          end     
% --------------------------------------------------------------------   
 case 'best4',                  switch upper(setVersion)
   case 'PRIMARY'
     setFile = 'PRIMARY/best4_numFeatures69_last_output_rand_87212.mat';
   case 'MET', 
     setFile = 'MET/';          end     
% --------------------------------------------------------------------   
 case 'best5',                  switch upper(setVersion)
   case 'PRIMARY'
     setFile = 'PRIMARY/best5_numFeatures74_last_output_rand_90096.mat';
   case 'MET', 
     setFile = 'MET/';          end     
% --------------------------------------------------------------------   
 case 'all6',                  switch upper(setVersion)
   case 'PRIMARY'
     setFile = 'PRIMARY/all6_numFeatures80_last_output_rand_73832.mat';
   case 'MET', 
     setFile = 'MET/';          end     

 
% --------------------------------------------------------------------  
 otherwise
      error('invalid set name');
end


load(['./datasets/',setFile]);                   % load selected dataset
setStats.means = mean(source_array');  % calculate mean of dataset
setStats.stds  =  std(source_array');  % calculate standard deviation

disp('------------------------------------------');
disp('successfully loaded dataset, description:');
disp(infostring);

%% merge categories
% merge categories for simple and complex stroma? optional.
if nargin>2 && strcmp(varargin{1},'merge')
    disp('- merging high grade tumor and low grade tumor');
    
    % merge category 2 (low grade tumor) with category 3 (high grade tumor)
    for j=2:9
        source_and_target(source_and_target(:,end)==j+1,end)=j;
    end
    
    % merge category 2 (low grade tumor) with category 3 (high grade tumor)
    target_array(2,target_array(3,:)==1) = 1;
    target_array(3,:) = [];

    % overwrite labels
    CatNames = {'Stroma', 'Tumor', 'Immune', 'Muscle', 'Liver', ...
        'Mucosa', 'Debris', 'Adipose', 'Background'};
else
    % prepare labels
    disp('merge: off');
    CatNames = strrep(TisCatsName,'_',' ');
end

%% restrict classes
% use only a subset of all classes
if nargin>3
    disp(['- restricting dataset to classes up to ', char(CatNames(varargin{2}))]);
    maxClass = varargin{2};
    source_and_target_restrict_classes = ...
        source_and_target(1:find(source_and_target(:,end)==(maxClass), 1, 'last' ),:);
    target_array(maxClass+1:end,:) = [];
else
    source_and_target_restrict_classes = source_and_target;
end

%% reduce dataset size
% choose a proportion of data (subsetSize), points are randomly picked
if nargin>4
    disp(['- reducing dataset size to ',num2str(varargin{3}*100),'%']);
    rng('default');
    subsetSize = varargin{3};
    subsetIdx = (rand(size(source_and_target_restrict_classes,1),1)<subsetSize);

    myFullData = ...
        source_and_target_restrict_classes(subsetIdx,:);
    myLabelCats = target_array(:,subsetIdx);
else
    myFullData = source_and_target_restrict_classes;
    myLabelCats = target_array;
end

%% return myData, myLabels, myLabelCats
myData = myFullData(:,1:end-1)';
myLabels = myFullData(:,end);

disp('------------------------------------------');

end