
function [folds, is_this_cross_validation, mus, stds] = load_and_prepare_data(training_data_path, test_data_path, features_list, problem_to_solve, num_of_folds)

    % if both training and test data are the same, then we are going to use
    % cross validation, and we must organize our data in a different way
    is_this_cross_validation = strcmp(training_data_path, test_data_path);

    % if this is cross validation
    if (is_this_cross_validation)
        
        % load labels
        data.labels = load_labels(training_data_path, problem_to_solve);
        % load features
        data.features = load_features(training_data_path, features_list);
        
        % prepare data partition file (it might not exist)
        partition_file = fullfile(training_data_path, 'partitions', 'cross-validation.mat');
        % if the partition file do not exist, then lets prepare one and
        % save
        if (exist(partition_file, 'file')==0)
            % organize data in 10 folds
            folds_indices = cross_validation_splits(data.labels, num_of_folds);
            % save current partition
            mkdir(fullfile(training_data_path, 'partitions'));
            save(partition_file, 'folds_indices');
        else
            % load partition file for this data set
            load(partition_file);
        end
        
        % organize features and labels in folds
        folds = organize_features_in_folds(folds_indices, data.features, data.labels, is_this_cross_validation);
        
    else
        
        % load labels for training data
        data.training_data.labels = load_labels(training_data_path, problem_to_solve);
        % load features for training data
        data.training_data.features = load_features(training_data_path, features_list);
        
        % load labels for test data
        data.test_data.labels = load_labels(test_data_path, problem_to_solve);
        % load features for the test data
        data.test_data.features = load_features(test_data_path, features_list);
        
        % prepare data partition file for the training data
        % (it might not exist)
        partition_file = fullfile(training_data_path, 'partitions', 'training-validation.mat');
        % if the partition file do not exist, then lets prepare one and
        % save
        if (exist(partition_file, 'file')==0)
            % organize data in 10 folds
            train_val_indices = train_val_splits(data.training_data.labels);
            % save current partition
            save(partition_file, 'train_val_indices');
        else
            % load partition file for this data set
            load(partition_file);
        end
        
        % organize features and labels in the training set into training
        % and validation
        folds = organize_features_in_folds(train_val_indices, data.training_data.features, data.training_data.labels, is_this_cross_validation);
        
        % and lets plug the test data to the only fold that we have
        folds{1}.test_data.features = data.test_data.features;
        folds{1}.test_data.labels = data.test_data.labels;
        
    end

    % normalize features
    [folds, mus, stds] = normalize_features(folds);

end



function labels = load_labels(data_path, problem_to_solve)

    % load labels
    current_labels = load(fullfile(data_path, 'labels', 'labels.mat'));
    
    % reassign current_labels.labels.dr to the variable to return
    labels = current_labels.labels.dr;
    
    % now, depending on the problem we want to solve, we will adapt the
    % labels
    switch problem_to_solve
        case 'dr-screening'
            % R0 = -1, R1-R2-R3 = 1
            labels = 2 * (labels > 0) - 1;
        case 'need-to-referral'
            % R0,R1 = -1, R2-R3 = 1
            labels = 2 * (labels > 1) - 1;
        case 'proliferative'
            % R0,R1,R2 = -1, R3 = 1
            labels = 2 * (labels > 2) - 1;
        otherwise
            error(['problem_to_solve unknown. "dr-screening", "need-to-referral" or "proliferative" expected, ', problem_to_solve, ' found.']);
    end

end


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


function folds = organize_features_in_folds(folds_indices, features, labels, is_cross_validation)
       
    % initialize folds
    folds = cell(length(folds_indices), 1);
    
    % prepare training, validation and test data
    for i = 1 : length(folds_indices)
        
        % get current features/labels for the training data
        folds{i}.training_data.features = features(folds_indices{i}.trainingIndices, :);
        folds{i}.training_data.labels = labels(folds_indices{i}.trainingIndices);
        
        % get current features/labels for the validation data
        folds{i}.validation_data.features = features(folds_indices{i}.validationIndices, :);
        folds{i}.validation_data.labels = labels(folds_indices{i}.validationIndices);

        if is_cross_validation
            % get current features/labels for the test data
            folds{i}.test_data.features = features(folds_indices{i}.testIndices, :);
            folds{i}.test_data.labels = labels(folds_indices{i}.testIndices);
        end
        
    end
    
end


function [folds, mus_, stds_] = normalize_features(folds)

    % initialize arrays for mean and standard deviations values
    mus_ = zeros(length(folds), size(folds{1}.training_data.features,2));
    stds_ = zeros(length(folds), size(folds{1}.training_data.features,2));

    % for each of the folds
    for i = 1 : length(folds)
        % standardize features on the training data, retrieving mean and 
        % standard deviation
        [folds{i}.training_data.features, mus_(i,:), stds_(i,:)] = ...
            standardizeCols(folds{i}.training_data.features);
        % standardize features on the validation and test set, using mu_ and
        % std_
        folds{i}.validation_data.features = ...
            standardizeCols(folds{i}.validation_data.features, mus_(i,:), stds_(i,:));
        folds{i}.test_data.features = ...
            standardizeCols(folds{i}.test_data.features, mus_(i,:), stds_(i,:));
    end

end


