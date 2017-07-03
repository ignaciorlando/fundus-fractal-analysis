
% SCRIPT_EXTRACT_FRACTAL_DIMENSIONS
% -------------------------------------------------------------------------
% This script extract different fractal dimensions from images processed
% with different approaches.
% -------------------------------------------------------------------------

warning('off','all');

config_extract_fractal_dimensions;

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

FDcap = zeros(length(input_filenames), 1);
FDinf = zeros(length(input_filenames), 1);
FDcor = zeros(length(input_filenames), 1);

% for each of the segmentations
for i = 1 : length(input_filenames)
    
    % read current input file
    current_input_for_fractal_analysis = imread(fullfile(input_path, input_filenames{i}));
    
    switch extract_from
        
        case 'vessels'
            % turn segmentation into a logical matrix
            current_input_for_fractal_analysis = current_input_for_fractal_analysis > 0;
            % post process it
            [current_input_for_fractal_analysis] = preprocess_segmentation(current_input_for_fractal_analysis);pin
            
        case 'skeleton'
            % turn segmentation into a logical matrix
            current_input_for_fractal_analysis = current_input_for_fractal_analysis > 0;
            % post process it
            [current_input_for_fractal_analysis] = preprocess_segmentation(current_input_for_fractal_analysis);
            % extract skeleton
            current_input_for_fractal_analysis = bwmorph(current_input_for_fractal_analysis, 'skel',Inf);
            
    end
    
    % processing image...
    fprintf('Processing image %d/%d - %s\n', i, length(input_filenames), input_filenames{i});
      
    % extract fractal dimensions
    % FDcap = Capacity Fractal Dimension (box counting)
    % FDinf = Information Fractal Dimension
    % FDcor = Correlation Fractal Dimension
    [ FDcap(i), FDinf(i), FDcor(i) ] = compute_fractal_dimensions(current_input_for_fractal_analysis);
    
end

%% save them to be used later

% initialize the output folder
output_folder = fullfile(dataset_path, dataset_name, 'features');
mkdir(output_folder);

% create the feature alias for FDcap and save
features = FDcap;
save(fullfile(output_folder, strcat('box-fractal-dimension-', output_tag, '.mat')), 'features');

% create the feature alias for FDinf and save
features = FDinf;
save(fullfile(output_folder, strcat('information-fractal-dimension-', output_tag, '.mat')), 'features');

% create the feature alias for FDcor and save
features = FDcor;
save(fullfile(output_folder, strcat('correlation-fractal-dimension-', output_tag, '.mat')), 'features');
