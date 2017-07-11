
% CONFIG_SEGMENT_VESSELS
% -------------------------------------------------------------------------
% This code is called by script_segment_vessels to set up the segmentation
% parameters.
% -------------------------------------------------------------------------

% datasets to segment
dataset_names = {...
    'MESSIDOR', ...
};

scale_values = [ ...
    0.81875, ...     % MESSIDOR
];


% folder where images, masks and stuff are stored
image_folder = 'C:\_diabetic_retinopathy';

% folder where vessel segmentations will be saved
output_segmentations_folder = 'C:\_diabetic_retinopathy';

% The segmentation model has to be located in this folder
modelLocation = 'C:\_diabetic_retinopathy\segmentation-model';

