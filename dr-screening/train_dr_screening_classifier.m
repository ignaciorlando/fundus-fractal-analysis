
function model = train_dr_screening_classifier(training_data, validation_data, classifier, mu, std)

    % train the classifier indicated in classifier
    switch classifier
        
        % random forest classifier
        case 'random-forest'
            fprintf('    Training random forest...\n');
            model = train_random_forest_classifier(training_data, validation_data);
        
        % L1 regularized logistic regression
        case 'l1-logistic-regression'
            fprintf('    Training L1 regularized logistic regression...\n');
            model = train_logistic_regression_classifier(training_data, validation_data, 'l1');
        
        % L2 regularized logistic regression
        case 'l2-logistic-regression'
            fprintf('    Training L2 regularized logistic regression...\n');
            model = train_logistic_regression_classifier(training_data, validation_data, 'l2');
        
        % wrong classifier, boy/girl
        otherwise
            error([classifier, ' classifier unknown']);
            
    end
    
    % assign mean and standard deviation
    model.mu = mu;
    model.std = std;

end


function model = train_random_forest_classifier(training_data, validation_data)

    % good news! with random forest we don't need a validation set, so we
    % can join everything within the same data set
    training_data.features = cat(1, training_data.features, validation_data.features);
    training_data.labels = cat(1, training_data.labels, validation_data.labels);

    % initialize an array of different number of trees
    number_of_trees = 100:100:1000;

    % quality values and models
    qualities_on_validation = zeros(length(number_of_trees), 1);
    models_per_quality_value = cell(size(qualities_on_validation));

    % for each tree
    for n_tree = 1 : length(number_of_trees)

        % train a RF from the training set
        rf = classRF_train(training_data.features, training_data.labels, number_of_trees(n_tree), sqrt(size(training_data.features,2)));
        % retrive current OOB error
        qualities_on_validation(n_tree) = rf.errtr(end,1);
        fprintf('    Number of trees=%d   OOB error rate=%d', number_of_trees(n_tree), qualities_on_validation(n_tree));
        models_per_quality_value{n_tree} = rf;

    end

    % Retrieve the best performance
    [best_performance, index] = min(qualities_on_validation(:));
    fprintf('    BEST PERFORMANCE:   OOB error = %d   -   Number of trees = %d\n\n', best_performance, number_of_trees(index));

    % assign to model the best that we found
    model.classifier = 'random-forest';
    model.rf = models_per_quality_value{index};
    model.num_trees = number_of_trees(index);
    model.validation_quality = best_performance;
    
end


function model = train_logistic_regression_classifier(training_data, validation_data, regularizer)

    % add a constant to features so we can simulate a bias terms
    training_data.features = cat(2, training_data.features, ones(size(training_data.features, 1), 1));
    validation_data.features = cat(2, validation_data.features, ones(size(validation_data.features, 1), 1));

    % initialize lambda values to analyze
    lambda_values = 10.^(-10:10);
    
    % initialize a matrix of qualities over validation
    qualities_on_validation = zeros(length(lambda_values), 1);
    % do the same for the models
    ws = cell(length(lambda_values), 1);

    % % set up the logistic loss
    funObj = @(w)LogisticLoss(w, training_data.features, training_data.labels);
    new_options.Display = 0;
    new_options.useMex = 0; 
    new_options.verbose = 0;
    
    % run for each lambda value
    for lambda_idx = 1 : length(lambda_values)

        % train the regularized logistic regresion depending on the
        % regularizer
        switch regularizer
            case 'l1'
                
                % % get current lambda                
                %lambda = ones(size(training_data.features,2),1) * lambda_values(lambda_idx) / 2;
                %lambda(end) = 0;
                lambda = lambda_values(lambda_idx) * ones(size(training_data.features,2),1);
                w = L1General2_PSSgb(funObj, zeros(size(training_data.features,2),1), lambda, new_options);

                % get current lambda                
                %lambda = lambda_values(lambda_idx);
                %[w, ~] = ksupLogisticRegression(training_data.features, training_data.labels, lambda, 1);
                
            case 'l2'
                
                % % get current lambda                
                %lambda = ones(size(training_data.features,2),1) * lambda_values(lambda_idx);
                %lambda(end) = 0;
                lambda = lambda_values(lambda_idx) * ones(size(training_data.features,2),1);
                w = minFunc(@penalizedL2, zeros(size(training_data.features,2),1), new_options, funObj, lambda); 

                % get current lambda                
                %lambda = lambda_values(lambda_idx);
                %[w, ~] = ksupLogisticRegression(training_data.features, training_data.labels, lambda, size(training_data.features, 2));
                
            otherwise
                error('Regularizer unknown. Please, use l1 or l2.');
        end
        % save current weights
        ws{lambda_idx} = w;

        % classify validation set
        validation_scores = w' * validation_data.features';

        % evaluate on the validation set and save current performance
        qualities_on_validation(lambda_idx) = evaluateResults(validation_data.labels, validation_scores, 'auc');
        fprintf('    lambda=%d   AUC=%d\n', lambda_values(lambda_idx), qualities_on_validation(lambda_idx));

    end
        
    % retrieve the higher quality value on the validation set
    [highest_performance, lambda_ind] = max(qualities_on_validation(:));
    fprintf('    HIGHEST PERFORMANCE:\n    lambda=%d   AUC=%d\n', lambda_values(lambda_ind), highest_performance);
    
    % assign to model the best that we found
    model.classifier = strcat(regularizer, '-logistic-regression');
    model.w = ws{lambda_ind};
    model.lambda = lambda_values(lambda_ind);
    model.validation_quality = highest_performance;

end