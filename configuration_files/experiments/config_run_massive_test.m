
% CONFIG_RUN_MASSIVE_TEST
% -------------------------------------------------------------------------
% This script is called by script_run_massive_test to set up the parameters
% that we need for applying cross-validation
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

list_of_fractal_dimensions = {...
    'box' ...
    'information' ...
    'correlation' ...
};

% Features to be used
list_of_features_to_try = {...
    'fractal-dimension-from-vessels' ... % Fractal dimension from vessels
    'fractal-dimension-from-skeleton' ... % Fractal dimension from skeleton
};

% Problems to solve
list_of_problems_to_try = {
    'dr-screening' ...  % DR screening: R0 vs. R1, R2, R3 and R4
    'need-to-referral' ... % Need to referral: R0 and R1 vs. R2, R3 and R4
    'proliferative' ... % Proliferative screening: R0, R1 and R2, R3 and R4
    'od-neovascularizations' ... % OD - neovascularization
};

% Classifier
list_of_classifiers_to_try = {
    'l1-logistic-regression' ... % L1 logistic regression
    'l2-logistic-regression' ... % L2 logistic regression
};

% Number of folds
num_of_folds = 5;