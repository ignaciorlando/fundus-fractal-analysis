
function [folds] = cross_validation_splits(labels, nFolds)

    cross_validation_structure = cvpartition(labels, 'KFold', nFolds);
    
    % Initialize the cell-array of splits
    folds = cell(nFolds, 1);
    for i = 1 : length(folds)
        
        % retrieve current indices on the training set
        current_training_set = find(cross_validation_structure.training(i));
        
        % create an array of indices
        indices_on_the_array = 1:1:length(current_training_set);
        
        % sort them randomly
        sorting = indices_on_the_array(randperm(length(indices_on_the_array)));
        current_training_set = current_training_set(sorting);
        
        % compute size of the validation set
        validationSize = floor((1 - 0.7) * length(sorting));
        
        % assign the first validationSize elements to the validation set
        folds{i}.validationIndices = current_training_set(1:validationSize);
        % and the remaining ones to the training set
        folds{i}.trainingIndices = current_training_set(validationSize+1:end);
        % and the test set... to the test set
        folds{i}.testIndices = find(cross_validation_structure.test(i));
    end
    

end