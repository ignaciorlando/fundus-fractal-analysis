
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
    case 'image'
        % prepare input tag
        input_tag = 'from-image';
    case 'inpainted'
        % prepare input tag
        input_tag = 'from-inpainted'; 
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

% also compute mutual information
mutual_information_matrix = zeros(length(fractal_dimensions));
for i = 1 : length(fractal_dimensions)
    for j = i : length(fractal_dimensions)
        mutual_information_matrix(i,j)=mutual_information(feature_array(:,i)',feature_array(:,j)');
        mutual_information_matrix(i,j)=mutual_information_matrix(j,i);
    end
end
mutual_information_matrix