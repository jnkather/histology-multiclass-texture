% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file in same folder, includes disclaimer

% this script is used to apply a given classifier to a large image in a
% tile-wise manner, e.g. 150 px square tiles with 50 px overlap. It
% contains an experimental feature (fractal classification) that is
% deactivated by default.

% HEADER
clear all, close all, clc

addpath([pwd,'/subroutines'],'-end'); % my own subroutines
addpath([pwd,'/lbp'],'-end');         % lbp subroutines
addpath([pwd,'/perceptual'],'-end');         % Bianconi et al. subroutines

% define some constants (paths, filenames and the like)
cnst.ApplicationInputDir = './test_cases/';  % specify folder for input images
cnst.parallel = true;              % parallel computing? 0 or 1. default 1
cnst.outputDir = './output/'; % where to save the results

% set block size for largest generation of blocks
cnst.CoreBlockSize = [50 50];     % default [50 50]
cnst.BorderSize =    [50 50];     % default [50 50]

% set feature set parameters
cnst.featureType = 'best5';
        
cnst.FeatureDataSource = 'PRIMARY';
cnst.numFeatures = getNumFeat(cnst.featureType);
cnst.maxClass = 8;
setStats.doScale = false; % not needed default false

% offsets for GLCM
cnst.offsets = getMyGLCMParams();

% settings for fractal tiling (this feature is experimental and is in fact
% overridden by setting cnst.maxFractal to 1
cnst.confidenceThresh = [3,2]; % confidence threshold for each fractal level
cnst.maxFractal = 1;           % must be 1 at the moment, could be increased
cnst.subTileMask = createSubtileMask(cnst);
cnst.noOverheat = true;

% load dataset to have all meta-variables available
[CatNames, myFullData, X, labels, myLabelCats] =...
    load_feature_dataset(cnst.featureType,cnst.FeatureDataSource);

% load classifier: manually change code if classifier is changed!
classifierFolder = 'UID_89838'; % classifier unique ID (UID) for "best5"
classifierName = 'UID_89838-row_8-MaxClass_8-Feat_best5-Data_PRIMARY-Classif_rbfSVM-CLASSIFIER';
load(['./output/',classifierFolder,'/',classifierName,'.mat']);

% iterate through images and apply classifier tile-wise
for curr_imname =  {'CRC-Prim-HE-02-APPLICATION.tif'}; 
    % specify one or more larger image file names as a cell array of
    % strings

curr_impath = [cnst.ApplicationInputDir, char(curr_imname)];

plotName = [char(curr_imname),' ',classifierName,' ',...
    num2str(cnst.CoreBlockSize(1)),'+',...
    num2str(cnst.BorderSize(1)),' ',cnst.featureType, ' scaling ',...
    num2str(setStats.doScale), ' ', cnst.FeatureDataSource];  % prepare title

% try to load existing image
try 
    load([cnst.outputDir,plotName,'.mat']);
    warning('Loaded existing dataset. Will not perform image analysis');
    countdown(10);
    elapsedTime = 0;
catch
    disp('Starting image analysis (block-wise) ...');
    tic
    %--- deploy classifier
    fun = @(blk) tileClassify_fractal(blk.data,trainedClassifier,...
        cnst.numFeatures,cnst.maxClass,cnst.featureType,cnst,setStats);
    imgResult = blockproc(curr_impath, cnst.CoreBlockSize, fun,...
                   'BorderSize',cnst.BorderSize, 'UseParallel',cnst.parallel,...
                   'PadPartialBlocks',true, 'PadMethod','symmetric',...
                   'TrimBorder',true);
    elapsedTime = toc;
end

showOriginalClassifiedConfidence(imgResult,cnst,plotName,curr_impath,CatNames); % show results

% save result
save([cnst.outputDir,plotName,'.mat'],'imgResult');

% optional: pause to avoid core overheat
if cnst.noOverheat, waitFor(elapsedTime,90); end

end

sound(sin(1:0.3:800));