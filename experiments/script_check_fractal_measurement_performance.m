
% SCRIPT_CHECK_FRACTAL_MEASUREMENT_PERFORMANCE
% -------------------------------------------------------------------------
% This script evaluates different fractal dimension performance for each
% classification problem, and plots a bar chart.
% -------------------------------------------------------------------------

config_check_fractal_measurement_performance;

%% initialize all parameters

% mean areas under the roc curves
mean_aucs_to_plot = zeros(length(list_of_features_to_try) * length(fractal_dimensions), length(classifiers_to_try));
% standard deviations for the roc curves
stds_aucs_to_plot = zeros(length(list_of_features_to_try) * length(fractal_dimensions), length(classifiers_to_try));

% indicate that it is already configured
is_configured = 1;
% don't save results
save_results = false;
% don't show intermediate plots
show_roc = false;

% set up the output path
output_fig_path = fullfile(output_fig_path, test_set_name, 'fractal-measurement-performance');

%% run!

figure;

% for each problem to solve
for jjj = 1 : length(classifiers_to_try)

    % get current problem to solve
    classifier = classifiers_to_try{jjj};

    % initialize the array of legends
    legends_to_plot = cell(size(mean_aucs_to_plot, 1), 1);
    
    % experiment counter
    counter = 0;   
        
    % for each fractal dimension
    for kkk = 1 : length(fractal_dimensions)

        % get current fractal dimension
        fractal_dimension = fractal_dimensions{kkk};
        
        % for each feature to try
        for iii = 1 : length(list_of_features_to_try)

            % get current feature
            features_to_use = list_of_features_to_try(iii); 
            
            % call the experiment
            script_train_kernelized_logistic_regression_classifier;
            counter = counter + 1;
            
            % save results
            mean_aucs_to_plot(counter, jjj) = mean_auc;
            stds_aucs_to_plot(counter, jjj) = std_auc;
            
            % add the legend
            legends_to_plot{counter} = [list_fractal_dimensions_tags{kkk}, ' - ', list_of_features_to_try_tags{iii}];
            
        end
        
    end
    
    % bar chart
    subplot(1,length(classifiers_to_try),jjj);
    barweb(mean_aucs_to_plot(:,jjj), ...
           stds_aucs_to_plot(:,jjj), [], [], [], [], [], bone, [], {}, 2, 'plot');
    xlabel(classifiers_tags{jjj},'Interpreter','LaTex');
    ylim([0.5 1]);
    ylabel('Area under the ROC curve','Interpreter','LaTex');
    if jjj==1
        h = legend(legends_to_plot, 'Location', 'southwest');
        set(h,'Interpreter','latex')
    end
    set(findall(gcf,'-property','FontSize'),'FontSize',14');
    set(gca,'ygrid','on');
    set(gca,'xtick',[]);
    
end

% create output folder
mkdir(output_fig_path);
% setup page size
fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
% output figure
savefig(fullfile(output_fig_path, strcat(problem_to_solve, '-bar_chart_fractal_measurement.fig')));
print(fullfile(output_fig_path, strcat(problem_to_solve, '-bar_chart_fractal_measurement.pdf')), '-dpdf');

