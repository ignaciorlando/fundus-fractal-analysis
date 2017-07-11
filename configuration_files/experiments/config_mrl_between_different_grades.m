
% CONFIG_GLM_BETWEEN_DIFFERENT_GRADES
% -------------------------------------------------------------------------

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

