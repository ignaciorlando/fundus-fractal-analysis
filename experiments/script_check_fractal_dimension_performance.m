
% SCRIPT_CHECK_FRACTAL_DIMENSION_PERFORMANCE
% -------------------------------------------------------------------------
% This script evaluates different fractal dimension performance for each
% classification problem, and plots a bar chart.
% -------------------------------------------------------------------------

config_check_fractal_dimension_performance;

%% initialize all parameters

% mean areas under the roc curves
aucs_to_plot = zeros(length(list_of_features_to_try) * length(fractal_dimensions), length(list_of_problems_to_try));

% indicate that it is already configured
is_configured = 1;
% don't save results
save_results = false;
% don't show intermediate plots
show_roc = false;

% set up the output path
output_fig_path = fullfile(output_fig_path, dataset_name, 'fractal-dimension-performance');

%% run!

figure;

% for each problem to solve
for jjj = 1 : length(list_of_problems_to_try)

    % get current problem to solve
    problem_to_solve = list_of_problems_to_try{jjj};

    % initialize the array of legends
    legends_to_plot = cell(size(aucs_to_plot, 1), 1);
    
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
            
            % concatenate each feature to use with the dimension
            features_to_use_names = cell(size(features_to_use));
            for i = 1 : length(features_to_use)
                features_to_use_names{i} = strcat(fractal_dimension, '-', features_to_use{i});
            end

            % prepare training data folder
            full_data_path = fullfile(data_path, dataset_name);
            % prepare results path
            full_results_path = fullfile(results_path, cell2mat(features_to_use));
            
            % load labels
            data.labels = load_labels(full_data_path, problem_to_solve);
            % load features
            data.features = load_features(full_data_path, features_to_use_names);
            % normalize features
            data.features = standardizeCols(data.features);
            
            % call the experiment
            [~, ~, info] = vl_roc(data.labels, data.features);
            counter = counter + 1;
            
            % save results
            aucs_to_plot(counter, jjj) = info.auc;
            
            % add the legend
            legends_to_plot{counter} = [list_fractal_dimensions_tags{kkk}, ' - ', list_of_features_to_try_tags{iii}];
            
        end
        
    end
    
    % bar chart
    subplot(1,length(list_of_problems_to_try),jjj);
    barweb(aucs_to_plot(:,jjj), ...
           zeros(size(aucs_to_plot(:,jjj))), [], [], [], [], [], bone, [], {}, 2, 'plot');
    xlabel(list_of_problems_to_try_tags{jjj},'Interpreter','LaTex');
    ylim([0.5 0.9]);
    ylabel('Area under the ROC curve','Interpreter','LaTex');
    if jjj==1
        h = legend(legends_to_plot, 'Location', 'northwest');
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
savefig(fullfile(output_fig_path, 'bar_chart_fractal_dimensions.fig'));
print(fullfile(output_fig_path, 'bar_chart_fractal_dimensions.pdf'), '-dpdf');

