
% CONFIG_BOXPLOT_PROLIFERATIVE_DR_SCREENING
% -------------------------------------------------------------------------
% This script is called by script_boxplot_proliferative_dr_screening 
% to configure the environment before plotting boxplots.
% -------------------------------------------------------------------------

% Name of the data set
dataset_name = 'MESSIDOR';

% Path where the data set is saved
dataset_path = '/Users/ignaciorlando/Documents/_fractal';

% Output path
output_path = '/Users/ignaciorlando/Dropbox/RetinalImaging/Writing/fractal2017paper/7609863whhhhrnpdvsh/figures/without-spurius';

% Fractal feature is going to be extracted from:
%extract_from = 'vessels';
extract_from = 'skeleton';


% Fractal dimension 
%fractal_dimension = 'box';
%fractal_dimension = 'information';
fractal_dimension = 'correlation';