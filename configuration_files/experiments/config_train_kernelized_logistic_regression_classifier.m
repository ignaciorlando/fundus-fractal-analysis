
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

% Features to be used
features_to_use = {...
    'fractal-dimension-vessels' ... % Fractal dimension from vessels
    'fractal-dimension-image' ... % Fractal dimension from image
    'fractal-dimension-skeleton' ... % Fractal dimension from skeleton
};

% Problem to solve
%problem_to_solve = 'dr-screening';
%problem_to_solve = 'need-to-referral';
problem_to_solve = 'proliferative';

% Classifier
%classifier = 'l1-logistic-regression';
%classifier = 'l2-logistic-regression';
classifier = 'random-forest';
%classifier = 'kernelized-logistic-regression';

% Number of folds
num_of_folds = 30;