
% CONFIG_MULTIPLE_FEATURES_LOGISTIC_REGRESSION_CLASSIFIER
% -------------------------------------------------------------------------
% This script is called by 
% config_multiple_features_logistic_regression_classifier to set
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
results_path      = '/Users/ignaciorlando/Dropbox/RetinalImaging/Writing/fractal2017paper/7609863whhhhrnpdvsh/figures/without-spurius';


% % Features to be used
% features_to_use_names = {...
%      'box-fractal-dimension-from-vessels' ... % Fractal dimension from vessels
%      'box-fractal-dimension-from-skeleton' ... % Fractal dimension from skeleton
%      'information-fractal-dimension-from-vessels' ... % Fractal dimension from vessels
%      'information-fractal-dimension-from-skeleton' ... % Fractal dimension from skeleton
%      'correlation-fractal-dimension-from-vessels' ... % Fractal dimension from vessels
%      'correlation-fractal-dimension-from-skeleton' ... % Fractal dimension from skeleton
% };

% % Features to be used
% features_to_use_names = {...
%      'box-fractal-measurement-from-vessels' ... % Fractal measurements from vessels
%      'box-fractal-measurement-from-skeleton' ... % Fractal measurements from skeleton
%      'information-fractal-measurement-from-vessels' ... % Fractal measurements from vessels
%      'information-fractal-measurement-from-skeleton' ... % Fractal measurements from skeleton
%      'correlation-fractal-measurement-from-vessels' ... % Fractal measurements from vessels
%      'correlation-fractal-measurement-from-skeleton' ... % Fractal measurements from skeleton
% };


% Features to be used
features_to_use_names = {...
     'box-fractal-measurement-from-vessels' ... % Fractal measurements from vessels
     'box-fractal-measurement-from-skeleton' ... % Fractal measurements from skeleton
     'information-fractal-measurement-from-vessels' ... % Fractal measurements from vessels
     'information-fractal-measurement-from-skeleton' ... % Fractal measurements from skeleton
     'correlation-fractal-measurement-from-vessels' ... % Fractal measurements from vessels
     'correlation-fractal-measurement-from-skeleton' ... % Fractal measurements from skeleton
     'box-fractal-dimension-from-vessels' ... % Fractal dimension from vessels
     'box-fractal-dimension-from-skeleton' ... % Fractal dimension from skeleton
     'information-fractal-dimension-from-vessels' ... % Fractal dimension from vessels
     'information-fractal-dimension-from-skeleton' ... % Fractal dimension from skeleton
     'correlation-fractal-dimension-from-vessels' ... % Fractal dimension from vessels
     'correlation-fractal-dimension-from-skeleton' ... % Fractal dimension from skeleton
};






% Problem to solve
%problem_to_solve = 'dr-screening';
%problem_to_solve = 'need-to-referral';
problem_to_solve = 'proliferative';

% Classifier
%classifier = 'l1-logistic-regression';
classifier = 'l2-logistic-regression';

file_tag = 'roc-curves';

% Number of folds
num_of_folds = 10;

% Save results
save_results = true;

% Show ROC
show_roc = true;