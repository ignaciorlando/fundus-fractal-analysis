
% CONFIG_EXTRACT_RED_LESION_FEATURES
% -------------------------------------------------------------------------
% This code is called by script_extract_red_lesion_features
% to set up basic parameters such as paths, etc.
% -------------------------------------------------------------------------

% Data set name
datasetName = 'MESSIDOR';

% Path where data sets are saved
root_path = '/Users/ignaciorlando/Documents/_fractal';

% Path where additional data such as vessel segmentations are saved
data_path = '/Users/ignaciorlando/Documents/_fractal';

% -------------------------------------------------------------------------
% RED LESION DETECTOR CONFIGURATION
% -------------------------------------------------------------------------

% Parameters for candidate extraction
L0 = 3;
step = 3;
L = 60;
K = 120;
px = 5;

% Training set name
training_set = generate_dataset_tag(fullfile('DIARETDB1', 'train'));
% Select the features source
features_source = 'combined';
% Select the classifier (by default, random forests)
classifier = 'random-forests';
% Select type of lesion
type_of_lesion = '';

% Folder where the trained model is saved and the name of the model
trained_model_path = fullfile(data_path, 'red-lesions-detection-model');
    % RF trained on combined or hand-crafted features
    trained_model_name = 'random-forests';

% CNN path
cnn_path = fullfile(data_path, 'red-lesions-detection-model');
    % DIARETDB1 training set
    cnn_filename = fullfile('cnn-from-scratch', 'softmax-lr=0.05-ceps=0.0001-lreps=0.01-wd=0.005-batch=100-N=10-dp=0.01-fc=128');    
    
