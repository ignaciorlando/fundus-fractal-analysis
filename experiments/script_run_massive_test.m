
% SCRIPT_RUN_MASSIVE_TEST
% -------------------------------------------------------------------------
% This script runs a massive test of different fractal features and
% different classifiers using any configuration you set up.
% -------------------------------------------------------------------------

config_run_massive_test;

% results tables
results_auc = zeros(length(list_of_problems_to_try), ...
                    length(list_of_features_to_try), ...
                    length(list_of_classifiers_to_try));
results_std = zeros(size(results_auc));                
    

% indicate that it is already configured
is_configured = 1;

% for each feature to try
for i = 1 : length(list_of_features_to_try)
    
    % get current feature
    features_to_use = list_of_features_to_try(i);
    
    % for each problem to solve
    for j = 1 : length(list_of_problems_to_try)
        
        % get current problem to solve
        problem_to_solve = list_of_problems_to_try{j};
        
        % for each classifier to try
        for k = 1 : length(list_of_classifiers_to_try)
            
            % get current classifier to try
            classifier = list_of_classifiers_to_try{k};
            
            % call the experiment
            script_train_kernelized_logistic_regression_classifier;
            close all
            
            % save results
            results_auc(j, i, k) = mean_auc;
            results_std(j, i, k) = std_auc;
            
        end
        
    end
    
    
end

