
% CONFIG_EXTRACT_FRACTAL_DIMENSIONS
% -------------------------------------------------------------------------
% This script is called by script_extract_fractal_dimensions to configure 
% the environment before extracting features.
% -------------------------------------------------------------------------

% Name of the data set
dataset_name = 'MESSIDOR';
%dataset_name = 'DR2';

% Path where the data set is saved
dataset_path = '/Users/ignaciorlando/Documents/_fractal';

% Fractal feature is going to be extracted from:
%extract_from = 'vessels';
%extract_from = 'skeleton';
extract_from = 'image';
%extract_from = 'inpainted';

% Indicate if you want to get only the slope (dimension) or the responses
% at different scales (measurements)
fractal_feature = 'dimension';
%fractal_feature = 'measurements';

