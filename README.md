# histology-multiclass-texture

## Contents
This repository contains MATLAB source code for the project "Texture analysis in colorectal cancer histology". Using this code, you can train a classifier with sample images of histological textures and apply this classifier to other histological images. A trained classifier is already included and can be applied to H&E images of colorectal carcinomas (20x magnification). Whereas all previously published approaches for colorectal cancer texture classification only address the two-class problem (tumor-stroma separation), this method is capable of classifying more than two tissue categories. In our paper, we investigated the classification of eight tissue categories, but the classifier can in principle handle any number of tissue categories.

The general workflow is as follow:

```
1. Use 'main_create_texture_feature_dataset.m' to create a feature vector for a given set of training images (specify the directory as 'cnst.inputDir' in 'main_create_texture_feature_dataset.m'). Then, manually change 'subroutines/load_feature_dataset.m' and specify the filename of the feature vector for further use.
2. Use 'main_trainClassifier.m' to train a classifier. Then, manually change 'classifierFolder' and 'classifierName' in main_deploy_classifier_fractal.m to specify which classifier should be used.
3. Use main_deploy_classifier_fractal.m to apply this classifier to unknown images. These images are typically located in './test_cases'
```

For more information, please refer to the following article. **Please cite this article when using the data set.**

Kather JN, Weis CA, Bianconi F, Melchers SM, Schad LR, Gaiser T, Marx A, Zollner F: Multi-class texture analysis in colorectal cancer histology (2016), Scientific Reports (in press)

## Raw data
All raw data used in this study are available on Zenodo under a Creative Commons Attribution license:
[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.53169.svg)](http://dx.doi.org/10.5281/zenodo.53169)

## License / Acknowledgements

The MIT license (available in the file "LICENSE") applies to all source codes within this repository. We want to thank Francesco Bianconi for providing (and permitting redistribution) of all source codes in the subfolder “perceptual”. Furthermore, we want to thank Matti Pietikäinen for providing (and permitting redistribution) of all source codes in the subfolder “lpb” (originally available from: http://www.cse.oulu.fi/CMV/Downloads/LBPMatlab).

## Contact
For questions, please contact: Jakob Nikolas Kather (http://orcid.org/0000-0002-3730-5348, ResearcherID: D-4279-2015)