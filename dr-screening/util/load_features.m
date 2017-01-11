
function features = load_features(data_path, features_list)

    % initialize an empty matriz of features
    features = [];
    
    % features_path will be data_path/features
    features_path = fullfile(data_path, 'features');
    
    % for each of the features in the feature list
    for i = 1 : length(features_list)
        
        % prepare current features path
        current_features_file = fullfile(features_path, strcat(features_list{i}, '.mat'));
        
        % check if the file is available
        if exist(current_features_file, 'file') == 0
            % if the file does not exists...
            error(['Cannot find ', features_list{i}, '.mat in folder ', features_path '. Make sure that the file was pre-computed before calling this function.'])
        else
            % load current features
            current_features = load(current_features_file);
            % concatenate them to the features array
            features = cat(2, features, current_features.features);
        end
        
    end

end