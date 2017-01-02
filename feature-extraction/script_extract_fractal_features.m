
config_extract_fractal_features;

%% prepare folders

switch extract_from

    case 'vessels' 
        % prepare segmentations path
        input_path = fullfile(dataset_path, dataset_name, 'segmentations');
        % retrieve segmentations names
        input_filenames = getMultipleImagesFileNames(input_path);
        % prepare output tag
        output_tag = 'fractal-dimension-vessels';
        
    case 'skeleton' 
        % prepare segmentations path
        input_path = fullfile(dataset_path, dataset_name, 'segmentations');
        % retrieve segmentations names
        input_filenames = getMultipleImagesFileNames(input_path);
        % prepare output tag
        output_tag = 'fractal-dimension-skeleton';    
        
    case 'image'
        % prepare segmentations path
        input_path = fullfile(dataset_path, dataset_name, 'images');
        % retrieve segmentations names
        input_filenames = getMultipleImagesFileNames(input_path);
        % prepare output tag
        output_tag = 'fractal-dimension-image';
        
end

%% process each segmentation

% initialize a matrix of features
features = zeros(length(input_filenames), 11);

% for each of the segmentations
for i = 1 : length(input_filenames)
    
    % read current input file
    current_input_for_fractal_analysis = imread(fullfile(input_path, input_filenames{i}));
    
    switch extract_from
        
        case 'vessels'
            % turn segmentation into a logical matrix
            current_input_for_fractal_analysis = current_input_for_fractal_analysis > 0;
            % apply a closing to compensate error in the central reflex
            current_input_for_fractal_analysis = imclose(current_input_for_fractal_analysis, strel('disk',2,8));
            
        case 'skeleton'
            % turn segmentation into a logical matrix
            current_input_for_fractal_analysis = current_input_for_fractal_analysis > 0;
            % apply a closing to compensate error in the central reflex
            current_input_for_fractal_analysis = imclose(current_input_for_fractal_analysis, strel('disk',2,8));
            % extract skeleton
            current_input_for_fractal_analysis = bwmorph(current_input_for_fractal_analysis, 'skel');
            
        case 'image'
            % get only the green band
            current_input_for_fractal_analysis = current_input_for_fractal_analysis(:,:,2);
            
    end
    
    % processing image...
    fprintf('Processing image %d/%d - %s\n', i, length(input_filenames), input_filenames{i});
    % extract fractal features
    fractal_features = boxcount(current_input_for_fractal_analysis);
    features(i,:) = fractal_features(1:11);
    
end

%% save them to be used later
output_folder = fullfile(dataset_path, dataset_name, 'features');
mkdir(output_folder);
save(fullfile(output_folder, strcat(output_tag, '.mat')), 'features');