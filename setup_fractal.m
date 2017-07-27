
% SETUP_FRACTAL
% -------------------------------------------------------------------------
% You have to run this code before doing anything else. This will set up
% the project path so you can have access to every function. It will also
% compile MEX files for you.
% Warning: you have to move your current folder to fundus-fractal-analysis
% before running this.
% -------------------------------------------------------------------------

% get current root position
my_root_position = pwd;

% add folders to path
addpath(genpath(fullfile(my_root_position, 'boxcount'))) ;
addpath(genpath(fullfile(my_root_position, 'data_organization'))) ;
addpath(genpath(fullfile(my_root_position, 'Util'))) ;
addpath(genpath(fullfile(my_root_position, 'feature-extraction')));
addpath(genpath(fullfile(my_root_position, 'external')));
addpath(genpath(fullfile(my_root_position, 'experiments')));
addpath(genpath(fullfile(my_root_position, 'machine-learning')));
addpath(genpath(fullfile(my_root_position, 'dr-screening')));

% add configuration files
addpath(genpath(fullfile(my_root_position, 'configuration_files'))) ;

% Set up Mark Schmidt code
cd('./external/markSchmidt');
% compiling minFunc functions
fprintf('Compiling minFunc files...\n');
mex -outdir minFunc minFunc/mcholC.c
mex -outdir minFunc minFunc/lbfgsC.c
mex -outdir minFunc minFunc/lbfgsAddC.c
mex -outdir minFunc minFunc/lbfgsProdC.c
%end
% Go back to the main folder
cd('..')
cd('..')


% if VLFeat does not exist, show a warning message
if exist(fullfile(my_root_position,'external','vlfeat','toolbox'), 'dir')==0
    warning('We could not find VLFeat. Please, download the package from here: http://www.vlfeat.org/download.html');
else
    addpath(fullfile(my_root_position,'external','vlfeat','toolbox')) ; % code for ROC curves and stuff
    % setup vl_feat
    vl_setup;
end

% Set up red lesion detection
cd('./external/red-lesion-detection/');
% compiling red lesion detection functions
dr_setup
% Go back to the main folder
cd('..')
cd('..')
rmpath(genpath('./external/red-lesion-detection/Scripts'))
rmpath(genpath('./external/red-lesion-detection/configuration'))
rmpath(genpath('./external/red-lesion-detection/default_configuration'))
rmpath(genpath('./external/red-lesion-detection/Util'))


clear
clc


