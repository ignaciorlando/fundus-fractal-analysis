
% SCRIPT_PERFORM_CORRELATION_ANALYSIS
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------

% configure the environment
config_perform_correlation_analysis

%% prepare paths and folders

% initialize the input folder
input_folder = fullfile(dataset_path, dataset_name, 'features');


%% run correlation analysis for each combination of fractal features

% initialize the cell array with all the feature arrays
feature_arrays = cell(size(extract_from));

% for each feature
for feat = 1 : length(extract_from)

    % prepare the input tag
    switch extract_from{feat}
        case 'vessels' 
            % prepare input tag
            input_tag = 'from-vessels';
        case 'skeleton' 
            % prepare input tag
            input_tag = 'from-skeleton';    
    end
    
    % initialize feature matrix
    feature_array = [];
    % for each of the fractal dimensions that will be considered
    for i = 1 : length(fractal_dimensions)
        % load features
        load(fullfile(input_folder, strcat(fractal_dimensions{i}, '-fractal-dimension-', input_tag, '.mat')));
        % assign
        feature_array = cat(2, feature_array, features);
        % plot scatter plot
    end

    % now, compute correlation
    fprintf('Fractal dimensions extracted %s - Correlation analysis\n\n', latex_legends_extract_form{feat});
    correlation_matrix = corr(feature_array)
    
    % add to the feature array
    feature_arrays{feat} = feature_array;

    % plot the scatter plots
    for i = 1 : length(fractal_dimensions) - 1
        for j = i + 1 : length(fractal_dimensions)
            
            % scatter plot
            figure, scatter(feature_array(:,i), feature_array(:,j));
            % retrieve min/max values
            min_value = min(cat(1, feature_array(:,i), feature_array(:,j)));
            max_value = max(cat(1, feature_array(:,i), feature_array(:,j)));
            % turn on box and grid
            box on, grid on
            % larger font size
            set(findall(gcf,'-property','FontSize'),'FontSize',16')
            % legend
            legend(latex_legends_extract_form{feat}, 'Location', 'southeast', 'Interpreter', 'LaTeX')
            % axis labels
            xlabel(latex_legends_dimensions{i}, 'Interpreter', 'LaTeX')
            ylabel(latex_legends_dimensions{j}, 'Interpreter', 'LaTeX')
            % preserve aspect ratio
            pbaspect([1 1 1])
            % prepare ticks
            new_ticks = textscan(num2str(min_value : (max_value - min_value) / 5:  max_value),'%s');
        end
    end
    
    
end

%% run correlation analysis between each type of fractal for each fractal object

% initialize a matrix of feature arrays
all_features = zeros(size(feature_arrays{1}, 1), ...
                     size(feature_arrays{1}, 2) * length(feature_arrays));

% add each set of features to add_features
first_coordinate = 1;
for i = 1 : length(feature_arrays)
    
    % add current features to the matrix
    all_features(:, first_coordinate : first_coordinate + length(fractal_dimensions) - 1) = ...
        feature_arrays{i};
    % update first_coordinate
    first_coordinate = 1 + length(fractal_dimensions);
    
end

% and now, compute correlations
for i = 1 : length(fractal_dimensions)
    
    fprintf('%s fractal dimensions - Correlation analysis\n\n', fractal_dimensions{i})
    [correlation_matrix, p_values] = corr(all_features(:,i:length(fractal_dimensions):size(all_features, 2)))
    
end

%% plot correlations for each fractal object

figure
scatter(all_features(:,1), all_features(:,4))
hold on
scatter(all_features(:,2), all_features(:,5))
scatter(all_features(:,3), all_features(:,6))
box on
grid on
legend(latex_legends_dimensions, 'Interpreter', 'LaTeX', 'Location', 'Southeast')
set(findall(gcf,'-property','FontSize'),'FontSize',14')
xlabel(latex_legends_extract_form{1}, 'Interpreter', 'LaTeX')
ylabel(latex_legends_extract_form{2}, 'Interpreter', 'LaTeX')
