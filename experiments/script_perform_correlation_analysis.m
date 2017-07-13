
% SCRIPT_PERFORM_CORRELATION_ANALYSIS
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------

% configure the environment
config_perform_correlation_analysis

%% prepare paths and folders

% initialize the input folder
input_folder = fullfile(dataset_path, dataset_name, 'features');

% setup input tag
switch extract_from
    case 'vessels' 
        % prepare input tag
        input_tag = 'from-vessels';
    case 'skeleton' 
        % prepare input tag
        input_tag = 'from-skeleton';    
end

%% 

% initialize feature matrix
feature_array = [];
% for each of the fractal dimensions that will be considered
for i = 1 : length(fractal_dimensions)
    % load features
    load(fullfile(input_folder, strcat(fractal_dimensions{i}, '-fractal-dimension-', input_tag, '.mat')));
    % assign
    feature_array = cat(2, feature_array, features);
end

% now, compute correlation
[correlation_matrix, p_values] = corr(feature_array)
