
% CONFIG_TRAIN_KERNELIZED_LOGISTIC_REGRESSION_CLASSIFIER
% -------------------------------------------------------------------------
% This script is called by 
% script_train_kernelized_logistic_regression_classifier to set
% up the parameters that we need for applying cross-validation
% -------------------------------------------------------------------------

% Training set name
training_set_name = 'MESSIDOR';
%training_set_name = 'DR2';

% Test set name
test_set_name     = 'MESSIDOR';
%training_set_name = 'DR2';

% Path where images and masks are saved
root_path         = '/Users/ignaciorlando/Documents/_fractal';
% Path where segmentations, features, etc are saved
data_path         = '/Users/ignaciorlando/Documents/_fractal';
% Results path
results_path      = '/Users/ignaciorlando/Documents/_fractal/_RESULTS';

% Type of fractal dimension
%fractal_dimension = 'box';
fractal_dimension = 'information';
%fractal_dimension = 'correlation';

% Features to be used
features_to_use = {...
     'fractal-dimension-from-vessels' ... % Fractal dimension from vessels
     'fractal-dimension-from-skeleton' ... % Fractal dimension from skeleton
};
% features_to_use = {...
%      'fractal-dimension-from-vessels' ... % Fractal dimension from vessels
%      'fractal-dimension-from-image' ... % Fractal dimension from image
%      'fractal-dimension-from-skeleton' ... % Fractal dimension from skeleton
%      'fractal-dimension-from-inpainted' ... % Fractal dimension from inpainted images
% };

% Problem to solve
problem_to_solve = 'dr-screening';
%problem_to_solve = 'need-to-referral';
%problem_to_solve = 'proliferative';

% Classifier
%classifier = 'l1-logistic-regression';
%classifier = 'l2-logistic-regression';
classifier = 'random-forest';

% Number of folds
num_of_folds = 10;

% Save results
save_results = true;

% Show ROC
show_roc = true;