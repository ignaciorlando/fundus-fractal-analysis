
% CONFIG_BOXPLOT_FRACTAL_DIMENSION_FOR_EACH_LABEL
% -------------------------------------------------------------------------
% This script is called by script_boxplot_fractal_dimension_for_each_label 
% to configure the environment before extracting features.
% -------------------------------------------------------------------------

% Name of the data set
dataset_name = 'MESSIDOR';
%dataset_name = 'DR2';

% Path where the data set is saved
dataset_path = '/Users/ignaciorlando/Documents/_fractal';

% Output path
output_path = '/Users/ignaciorlando/Dropbox/RetinalImaging/Writing/fractal2017paper/7609863whhhhrnpdvsh/figures/without-spurius';

% Fractal feature is going to be extracted from:
%extract_from = 'vessels';
extract_from = 'skeleton';


% Fractal dimension 
fractal_dimension = 'box';
%fractal_dimension = 'information';
%fractal_dimension = 'correlation';