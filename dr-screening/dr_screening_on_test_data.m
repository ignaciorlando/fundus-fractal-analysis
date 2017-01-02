
function scores = dr_screening_on_test_data(test_data, model)

    % train the classifier indicated in classifier   
    if strcmp(model.classifier, 'random-forest')
        % random forest classifier
        scores = dr_screening_with_random_forest(test_data, model);
    elseif strcmp(model.classifier, 'l1-logistic-regression') || ...
            strcmp(model.classifier, 'l2-logistic-regression') || ...
            strcmp(model.classifier, 'k-sup-logistic-regression')
        % logistic regression
        scores = dr_screening_with_logistic_regression(test_data, model);
    else
        % wrong classifier, boy/girl
        error([classifier, ' classifier unknown']);
    end

end



function scores = dr_screening_with_random_forest(test_data, model)

    % initialize the array of scores
    scores = zeros(size(test_data.features, 1), 1);
    % for each image, predict the score
    for i = 1 : size(test_data.features, 1)
        scores(i) = classRF_predict_probabilities(test_data.features(i,:), model.rf);
    end

end



function scores = dr_screening_with_logistic_regression(test_data, model)

    % concatenate a constant to simulate a bias term and then compute the
    % scores
    scores = model.w' * cat(2, test_data.features, ones(size(test_data.features,1), 1))';

end