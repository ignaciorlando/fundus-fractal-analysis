
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
        partition_file = fullfile(training_data_path, 'partitions', strcat('cross-validation-', num2str(num_of_folds),'.mat'));
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
