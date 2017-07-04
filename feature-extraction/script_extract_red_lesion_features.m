
% SCRIPT_EXTRACT_RED_LESION_FEATURES
% -------------------------------------------------------------------------
% This script computes red lesion based features for each image of a 
% given data set. If the red lesions were not segmented before, we do it 
% for you!
% -------------------------------------------------------------------------

config_extract_red_lesion_features;

% Prepare root path of data sets
root_path = fullfile(root_path, datasetName);
% Prepare dataset path
data_path = fullfile(data_path, datasetName);
% Prepare path for red lesions
red_lesion_path = fullfile(data_path, 'red-lesions-segmentations', 'combined', 'random-forests', cnn_filename);

% get image filenames
img_names = getMultipleImagesFileNames(fullfile(root_path, 'images'));

% get masks filenames
mask_names = getMultipleImagesFileNames(fullfile(root_path, 'masks'));
% get vessel segmentation filenames
vessel_segm_names = getMultipleImagesFileNames(fullfile(root_path, 'segmentations'));
% Prepare path for the red lesion detector (in case we don't have the
% precomputed segmentations)
trained_model_file = fullfile(trained_model_path, training_set, 'combined', cnn_filename, strcat(trained_model_name, '.mat'));
cnn_fullpath = fullfile(trained_model_path, training_set, strcat(cnn_filename, '.mat'));
% Load the pretrained net
cnn_for_feature_extraction = load(cnn_fullpath);
% Prepare it for feature extraction
[cnn_for_feature_extraction.net] = prepareCNNforExtractingFeatures(cnn_for_feature_extraction.detector.net);
% Create the red lesion path
mkdir(red_lesion_path);
% load the trained model for red lesion detection
load(trained_model_file);

% initialize feature matrix
features = zeros(length(img_names), 1);

% for each image...
for i = 1 : length(img_names)

    % prepare red lesion probability map name
    red_lesion_probability_map_filename = fullfile(red_lesion_path, strcat(img_names{i}, '.mat'));
    
    % check if the probability map of red lesions exist
    if exist(red_lesion_probability_map_filename, 'file') == 0
        
        fprintf('Couldnt find probability map for image %i/%i. Computing...\n', i, length(img_names));
        
        % open image
        I = imread(fullfile(root_path, 'images', img_names{i}));
        % open vessel segmentations
        vessel_segmentation = imread(fullfile(data_path, 'segmentations', vessel_segm_names{i}));
        % open FOV mask
        mask = imread(fullfile(root_path, 'masks', mask_names{i}));
        
        % segment red lesions
        [red_lesion_segmentation, score_map] = full_red_lesion_segmentation(I, mask, L0, step, L, K, px, cnn_for_feature_extraction, vessel_segmentation, detector);
        
        % save the segmentation and the probability map
        imwrite(red_lesion_segmentation, fullfile(red_lesion_path, strcat(img_names{i}, '.gif')));
        save(red_lesion_probability_map_filename, 'score_map');
        
    else
        
        % read red lesion segmentation
        load(red_lesion_probability_map_filename);
        
    end
    
    fprintf('Extracting features from image %i/%i\n', i, length(img_names));
   
    % sum all the red lesion in the segmentation
    features(i, :) = max(score_map(:));
    
end


% save the features file
mkdir(fullfile(data_path, 'features'));
save(fullfile(data_path, 'features', 'red-lesion-probability.mat'), 'features');
