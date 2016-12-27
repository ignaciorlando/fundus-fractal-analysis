
config_extract_fractal_features;

%% prepare folders

% prepare segmentations path
segmentation_path = fullfile(dataset_path, dataset_name, 'segmentations');

% retrieve segmentations names
segmentation_filenames = getMultipleImagesFileNames(segmentation_path);

%% process each segmentation

% initialize a matrix of features
features = zeros(length(segmentation_filenames), 11);

% for each of the segmentations
for i = 1 : length(segmentation_filenames)
    
    % read current segmentation file
    segm = imread(fullfile(segmentation_path, segmentation_filenames{i})) > 0;
    % apply a closing to compensate error in the central reflex
    segm = imclose(segm, strel('disk',2,8));
    % get structures with more than 100 pixels
    segm = bwareaopen(segm, 100);
    % processing image...
    fprintf('Processing image %d/%d - %s\n', i, length(segmentation_filenames), segmentation_filenames{i});
    % extract fractal features
    features(i,:) = boxcount(segm);
    
end

% normalize to zero mean and unit variance
features = bsxfun(@rdivide, bsxfun(@minus, features, mean(features)), std(features)+eps);

%% save them to be used later
output_folder = fullfile(dataset_path, dataset_name, 'fractal-features');
mkdir(output_folder);
save(fullfile(output_folder, 'features.mat'), 'features');