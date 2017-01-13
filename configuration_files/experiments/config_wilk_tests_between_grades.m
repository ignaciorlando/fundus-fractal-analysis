
% CONFIG_WILK_TESTS_BETWEEN_GRADES
% -------------------------------------------------------------------------
% This script is called by script_wilk_tests_between_grades to set up
% variables before running
% -------------------------------------------------------------------------

% Data set name
dataset_name = 'MESSIDOR';

% Path where images and masks are saved
dataset_path      = '/Users/ignaciorlando/Documents/_fractal';
% Results path
results_path      = '/Users/ignaciorlando/Documents/_fractal/_RESULTS';

% List of fractal dimensions to use
list_of_fractal_dimensions = {...
    'box' ...
    'information' ...
    'correlation' ...
};

% Features to be used
%image_source = 'fractal-dimension-from-vessels'; % Fractal dimension from vessels
image_source = 'fractal-dimension-from-skeleton'; % Fractal dimension from skeleton

