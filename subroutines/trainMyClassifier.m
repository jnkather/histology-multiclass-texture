% created by Jakob Nikolas Kather 2015 - 2016
% license: see separate LICENSE file in same folder, includes disclaimer

function [trainedClassifier, validationAccuracy, ConfMat, ROCraw] = ...
    trainMyClassifier(DataIn,classNames,NcrossVal,classifMethod)

switch lower(classifMethod)
    % --------------- NEURAL
    case 'neural'
    % NOTE: the dataset could also be classified by a neural network. When 
    % using the MATLAB GUI nprtool, a well-performing neural network can be
    % easily trained and classification accuracy is very high (comparable
    % to SVM). However, the network cannot be used by embedding the code
    % for network training here. Reason: command-line function "patternnet"
    % (as used in the MATLAB documentation) performs extremely poorly
    % (classification accuracy <50%). Did not find the reason so far.
    
    [trainedClassifier, validationAccuracy,ConfMat, ROCraw] = ...
     trainMyNetwork(DataIn,NcrossVal);
        
    otherwise
    % --------------- OTHER THAN NEURAL 
    numFeat = size(DataIn,2) - 1; numResp = 1; % no. of features and response

    % Convert input to table
    DataIn = table(DataIn); DataIn.Properties.VariableNames = {'column'};

    % prepare column names
    nameMat = 'column_1#';
    for i=2:(numFeat+numResp), nameMat = [nameMat,['#column_',num2str(i)]]; end
    colnames = strsplit(nameMat,'#');

    % Split matrices in the input table into vectors
    DataIn = [DataIn(:,setdiff(DataIn.Properties.VariableNames, ...
        {'column'})), array2table(table2array(DataIn(:,{'column'})), ...
        'VariableNames', colnames)];

    % Extract predictors and response, convert to arrays
    predictorNames = colnames(1:(end-1));    responseName = colnames(end);
    predictr = DataIn(:,predictorNames);   response = DataIn(:,responseName);
        predictr = table2array(varfun(@double, predictr));
        response = table2array(varfun(@double, response));
        
    disp('start training...');
    switch lower(classifMethod)
        
        % --------------- support vector machine (SVM)
        case {'rbfsvm','linsvm'}
            switch lower(classifMethod)
                case 'rbfsvm' % radial basis function SVM
                template = templateSVM('KernelFunction', 'rbf', 'PolynomialOrder', ...
                    [], 'KernelScale', 'auto', 'BoxConstraint', 1, 'Standardize', 1);
                case 'linsvm' % linear SVM
                template = templateSVM('KernelFunction', 'linear', 'PolynomialOrder', ...
                [], 'KernelScale', 'auto', 'BoxConstraint', 1, 'Standardize', 1);
            end % end svm subtypes, start svm common part
            trainedClassifier = fitcecoc(predictr, response, ...
                'Learners', template, 'Coding', 'onevsone',...
                'PredictorNames', predictorNames, 'ResponseName', ...
                char(responseName), 'ClassNames', classNames);
        % --------------- ensemble of decision trees           
        case 'ensembletree'
            template = templateTree(...
                'MaxNumSplits', 20); 
            trainedClassifier = fitensemble(...
                predictr, ...
                response, ...
                'RUSBoost', ...
                30, ...
                template, ...
                'Type', 'Classification', ...
                'LearnRate', 0.1, ...
                'ClassNames', classNames);
        % --------------- 1-nearest neighbor (1-NN)
        case '1nn'
            trainedClassifier = fitcknn(predictr, response, 'PredictorNames',...
                predictorNames, 'ResponseName', char(responseName), 'ClassNames', ...
                classNames, 'Distance', 'Euclidean', 'Exponent', '',...
                'NumNeighbors', 1, 'DistanceWeight', 'Equal', 'StandardizeData', 1);
    end % end svm or not svm
    
    % ------ all non-neural methods continuing here
    % Perform cross-validation = re-train and test the classifier K times
    disp('start cross validation...');
    partitionedModel = crossval(trainedClassifier, 'KFold', NcrossVal);
    disp('properties of partitioned set for cross validation'); partitionedModel.Partition
    % Compute validation accuracy on partitioned model
    disp('start validation...'); 
    validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
    % Compute validation predictions and scores
    disp('computing validation predictions and scores...');
    [validationPredictions, validationScores] = kfoldPredict(partitionedModel);
    ConfMat = confusionmat(response,validationPredictions);
    % Prepare data for ROC curves (reformat arrays)
    trues = zeros(numel(unique(response)),size(response,1));
    for i = 1:numel(unique(response)), trues(i,response==i) = 1; end
    ROCraw.true = trues; ROCraw.predicted = validationScores;
    
end % end neural or not neural
end % end function