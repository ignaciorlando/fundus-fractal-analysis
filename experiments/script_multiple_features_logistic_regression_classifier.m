
% SCRIPT_MULTIPLE_FEATURES_LOGISTIC_REGRESSION_CLASSIFIER
% -------------------------------------------------------------------------
% This script organize data, train a classifier and evaluate on a test set
% or using cross-validation for DR screening. The main difference with
% respect to script_train_kernelized_logistic_regression_classifier is in
% the feature organization.
% -------------------------------------------------------------------------

if exist('is_configured', 'var')==0
    config_multiple_features_logistic_regression_classifier;
end

%% prepare folders, load data and organize

% prepare training data folder
training_data_path = fullfile(data_path, training_set_name);
% prepare test data folder
test_data_path = fullfile(data_path, test_set_name);
% prepare results path
full_results_path = fullfile(results_path, cell2mat(features_to_use_names));

% load and prepare data
[folds, is_cross_validation, mus, stds] = load_and_prepare_data(training_data_path, test_data_path, features_to_use_names, problem_to_solve, num_of_folds);

%% evaluate features and classifier using this configuration

% if it is cross validation
if is_cross_validation
    % crossvalidate over the validation set
    scores = cross_validate_dr_screening_classifier(folds, classifier, mus, stds);
else
    % train a classifier
    model = train_dr_screening_classifier(folds{1}.training_data, folds{1}.validation_data, classifier, mus, stds);
    % evaluate on the test set
    scores = dr_screening_on_test_data(test_data, model);
end

% estimate performance on the test set
fprintf('\n\n--------------------------------------------\n');
fprintf('Final evaluation:\n');
[mean_tpr, mean_fpr, mean_auc, std_auc, std_tpr] = evaluate_dr_screening_performance(folds, scores);
fprintf('Mean AUC = %d\nStdev AUC = %d\n', mean_auc, std_auc);
fprintf('--------------------------------------------\n');

%% save and plot results

% plot ROC curve
if (show_roc)
    current_figure = gcf;
    if strcmp(current_figure.Name, 'mean-roc-curves')
        hold on;
    else
        current_figure = figure;
        current_figure.Name = 'mean-roc-curves';
    end
    
    if isempty(strfind(features_to_use_names{1},'dimension'))
        line_style = '-';
    else
        line_style = '--';
    end
    
    if strcmp(classifier,'l1-logistic-regression')
        line_color = 'b';
    else
        line_color = 'r';
    end
    
    plot(mean_fpr, mean_tpr, 'LineWidth', 2, 'Color', line_color, 'LineStyle', line_style);
%     current_figure = gcf;
%     if strcmp(current_figure.Name, 'mean-roc-curves')
%         hold on;
%         lineProps.col = {[0 0 1]};
%         lineProps.style = '--';        
%     else
%         current_figure = figure;
%         current_figure.Name = 'mean-roc-curves';
%         lineProps.col = {[0 0 1]};
%     end
%     if is_cross_validation
%         mseb(mean_fpr', mean_tpr', std_tpr', lineProps, 1);
%         legend(['AUC = ', num2str(mean_auc), '\pm', num2str(std_auc)], 'Location', 'southeast');
%     else
%         plot(mean_fpr, mean_tpr, 'LineWidth', 2);
%         legend(['AUC = ', num2str(mean_auc)], 'Location', 'southeast');
%     end
    box on; grid on;
    xlim([0 1]); ylim([0 1]);
    hold off
end

% it results have to be saved
if (save_results)
    % prepare a file tag
    if (is_cross_validation)
        file_tag = strcat(problem_to_solve, '--cross-validation-', num2str(num_of_folds), '-', training_set_name, '--', classifier);
    else
        file_tag = strcat(problem_to_solve, '--training-', training_set_name, '--test-', test_set_name, '--', classifier);
    end
    % save results
    mkdir(full_results_path);
    save(fullfile(full_results_path, strcat(file_tag,'.mat')), 'mean_tpr', 'mean_fpr', 'mean_auc', 'std_auc', 'std_tpr', 'problem_to_solve', 'training_set_name', 'test_set_name');
    savefig(fullfile(full_results_path, strcat(file_tag, '.fig')));
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    fig_pos = fig.PaperPosition;
    fig.PaperSize = [fig_pos(3) fig_pos(4)];
    print(fullfile(full_results_path, strcat(file_tag, '.pdf')), '-dpdf');
end