
% CONFIG_SEGMENT_VESSELS
% -------------------------------------------------------------------------
% This code is called by script_segment_vessels to set up the segmentation
% parameters.
% -------------------------------------------------------------------------

% datasets to segment
dataset_names = {...
    'MESSIDOR', ...
};

% folder where images, masks and stuff are stored
image_folder = '/Users/ignaciorlando/Documents/_fractal';

% folder where vessel segmentations will be saved
output_segmentations_folder = '/Users/ignaciorlando/Documents/_fractal';

% The segmentation model has to be located in this folder
modelLocation = '/Users/ignaciorlando/Documents/_fractal/segmentation-model';

% Size of the vessel_of_interest in DRIVE
vessel_of_interest = 7.0667;