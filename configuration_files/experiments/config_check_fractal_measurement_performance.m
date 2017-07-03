
% CONFIG_CHECK_FRACTAL_MEASUREMENT_PERFORMANCE
% -------------------------------------------------------------------------
% This script is called by script_check_fractal_measurement_performance
% to set up the parameters that we need for applying cross-validation
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
% Output figures path
output_fig_path   = '/Users/ignaciorlando/Dropbox/RetinalImaging/Writing/fractal2017paper/experiments';

% Fractal dimension
fractal_dimensions = { ...
    'box' ...
    'information' ...
    'correlation' ...
};
list_fractal_dimensions_tags = { ...
    '$N(r)$' ...
    '$H(r)$' ...
    '$C(r)$' ...
};

% Features to be used
list_of_features_to_try = {...
    'fractal-measurement-from-vessels' ... % Fractal dimension from vessels
    'fractal-measurement-from-skeleton' ... % Fractal dimension from skeleton
};

list_of_features_to_try_tags = {...
    'Vessel segmentation' ... % Fractal dimension from vessels
    'Skeletonized vasculature' ... % Fractal dimension from skeleton
};

% Problems to solve
problem_to_solve = 'proliferative'; % Proliferative screening: R0, R1, R2 and R3 vs. R4

% Classifier
classifiers_to_try = {...
    'l1-logistic-regression' ... % L1 logistic regression
    'l2-logistic-regression' ... % L2 logistic regression
};
classifiers_tags = {...
    '$\ell_1$ regularized logistic regression' ...
    '$\ell_2$ regularized logistic regression' ...
};

% Number of folds
num_of_folds = 10;