
% SCRIPT_EXTRACT_FRACTAL_DIMENSIONS
% -------------------------------------------------------------------------
% This script extract different fractal dimensions from images processed
% with different approaches.
% -------------------------------------------------------------------------

config_extract_fractal_features;

%% prepare folders

switch extract_from

    case 'vessels' 
        % prepare segmentations path
        input_path = fullfile(dataset_path, dataset_name, 'segmentations');
        % retrieve segmentations names
        input_filenames = getMultipleImagesFileNames(input_path);
        % prepare output tag
        output_tag = 'from-vessels';
        
    case 'skeleton' 
        % prepare segmentations path
        input_path = fullfile(dataset_path, dataset_name, 'segmentations');
        % retrieve segmentations names
        input_filenames = getMultipleImagesFileNames(input_path);
        % prepare output tag
        output_tag = 'from-skeleton';    
        
end

%% process each segmentation

% initialize arrays of fractal dimensions:

n_cap = zeros(length(input_filenames), 11);
n_inf = zeros(length(input_filenames), 11);
n_corr = zeros(length(input_filenames), 11);

% for each of the segmentations
for i = 1 : length(input_filenames)
    
    % read current input file
    current_input_for_fractal_analysis = imread(fullfile(input_path, input_filenames{i}));
    
    switch extract_from
        
        case 'vessels'
            % turn segmentation into a logical matrix
            current_input_for_fractal_analysis = current_input_for_fractal_analysis > 0;
            % post process it
            [current_input_for_fractal_analysis] = preprocess_segmentation(current_input_for_fractal_analysis);
            
        case 'skeleton'
            % turn segmentation into a logical matrix
            current_input_for_fractal_analysis = current_input_for_fractal_analysis > 0;
            % post process it
            [current_input_for_fractal_analysis] = preprocess_segmentation(current_input_for_fractal_analysis);
            % extract skeleton
            current_input_for_fractal_analysis = bwmorph(current_input_for_fractal_analysis, 'skel', Inf);
            
    end
    
    % processing image...
    fprintf('Processing image %d/%d - %s\n', i, length(input_filenames), input_filenames{i});
      
    % extract fractal measurements
    [current_n_cap, current_n_inf, current_n_corr, r] = compute_fractal_measurements(current_input_for_fractal_analysis);
    
    % assign current fractal measurements
    n_cap(i, 1:length(current_n_cap)) = current_n_cap;
    n_inf(i, 1:length(current_n_inf)) = current_n_inf;
    n_corr(i, 1:length(current_n_corr)) = current_n_corr;
    
end

%% save them to be used later

% initialize the output folder
output_folder = fullfile(dataset_path, dataset_name, 'features');
mkdir(output_folder);

% create the feature alias for FDcap and save
features = n_cap;
save(fullfile(output_folder, strcat('box-fractal-measurement-', output_tag, '.mat')), 'features');

% create the feature alias for FDinf and save
features = n_inf;
save(fullfile(output_folder, strcat('information-fractal-measurement-', output_tag, '.mat')), 'features');

% create the feature alias for FDcor and save
features = n_corr;
save(fullfile(output_folder, strcat('correlation-fractal-measurement-', output_tag, '.mat')), 'features');
