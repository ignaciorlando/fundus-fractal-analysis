
function [scores, models] = cross_validate_dr_screening_classifier(folds, classifier, mus, stds)

    % initialize array of scores and models (one per fold)
    scores = cell(length(folds), 1);
    models = cell(length(folds), 1);
    
    % for each of the folds
    for i = 1 : length(folds)
        
        fprintf('\nCross validation - Current fold = %d/%d\n\n', i, length(scores));
        
        % train the classifier on training/validation set
        models{i} = train_dr_screening_classifier(folds{i}.training_data, ...
            folds{i}.validation_data, classifier, mus(i,:), stds(i,:));
        
        % generate scores or probabilities
        scores{i} = dr_screening_on_test_data(folds{i}.test_data, models{i});
        
    end

end