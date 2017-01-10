
% SCRIPT_BOXPLOT_PROLIFERATIVE_DR_SCREENING
% -------------------------------------------------------------------------
% This script is used to plot boxplots for proliferative DR screening. It
% plots a boxplot in which fractal dimensions are grouped in two
% categories, R0-1-2 and R3.
% -------------------------------------------------------------------------

% configure the environment
config_boxplot_proliferative_dr_screening;

%% load labels and features

% initialize the input folder
input_folder = fullfile(dataset_path, dataset_name, 'features');

% load features accordingly
switch extract_from
    case 'vessels' 
        % prepare input tag
        input_tag = 'from-vessels';
    case 'skeleton' 
        % prepare input tag
        input_tag = 'from-skeleton';    
end

% switch for fractal dimension
switch fractal_dimension
    case 'box'
        fractal_dim_tag = '$D_B$';
    case 'information'
        fractal_dim_tag = '$D_I$';
    case 'correlation'
        fractal_dim_tag = '$D_C$';
end

% load features
load(fullfile(input_folder, strcat(fractal_dimension, '-fractal-dimension-', input_tag, '.mat')));

% load labels
load(fullfile(dataset_path, dataset_name, 'labels', 'labels.mat'));

%% retrieve features per each label

% retrieve unique labels
labels.dr = labels.dr > 2;
unique_labels = unique(labels.dr);

% initialize the array of features per label
features_per_r = cell(length(unique_labels), 1);
% initialize an array of groups
grouping_var = zeros(length(labels.dr), 1);
% initialize an array of legends
legend_array = {'R0-2', 'R3'};

% for each of the labels
iterator = 1;
for i = 1 : length(unique_labels)
    
    % retrieve features with current label
    features_per_r{i} = features(labels.dr == unique_labels(i), :);
    % assign grouping variables
    grouping_var(iterator : iterator + length(features_per_r{i}) - 1) = i;
    % update iterator
    iterator = iterator + length(features_per_r{i});
    
end

%% plot boxplots

% transform cell array to classic array
features_per_r = cell2mat(features_per_r);

% plot the boxplot
figure;
set(gcf, 'Position', [200 200 200 400]);
boxplot(features_per_r, grouping_var, 'notch', 'on');
set(gca,'ygrid','on');
% assign labels
set(gca,'XTick',1:length(unique_labels),'XTickLabel',legend_array);
set(findall(gcf,'-property','FontSize'),'FontSize',14)
%ah=copyobj(gca,gcf);
%set(ah,'YAxisLocation','right');
ylabel(fractal_dim_tag, 'Interpreter','LaTex');





% initialize output folder
figure_output_folder = fullfile(output_path, 'box-plots-proliferative');
mkdir(figure_output_folder);

% save it
%savefig(fullfile(figure_output_folder, strcat(fractal_dimension, '-fractal-dimension-', input_tag)));

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fullfile(figure_output_folder, strcat(fractal_dimension, '-fractal-dimension-', input_tag, '.pdf')), '-dpdf');