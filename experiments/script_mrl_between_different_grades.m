
% SCRIPT_MRL_BETWEEN_DIFFERENT_GRADES
% -------------------------------------------------------------------------
% Multinomial Regression for Ordinal Responses
% -------------------------------------------------------------------------

close all
clear
clc
config_mrl_between_different_grades

%% prepare paths and load labels

% initialize the input folder
input_folder = fullfile(dataset_path, dataset_name, 'features');

% load labels
load(fullfile(dataset_path, dataset_name, 'labels', 'labels.mat'));

% identify unique grades
labels.dr(labels.dr>4) = 4;
unique_grades = unique(labels.dr);

%% perform

% my response variable will be the DR grade
dr_grades = ordinal(labels.dr);

% prepare a matrix with all the fractal dimensions
% for each fractal dimension
X = zeros(length(dr_grades), length(list_of_fractal_dimensions));
for i = 1 : length(list_of_fractal_dimensions)
    
    % get current fractal dimension
    current_fractal_dimension = list_of_fractal_dimensions{i};
    % load features
    load(fullfile(input_folder, strcat(current_fractal_dimension, '-', image_source, '.mat')));
    % assign to the design matrix
    X(:, i) = features;
    
end

% Multinomial Regression for Ordinal Responses
% X: my design matrix.
% dr_grades: my response 
disp('Multinomial Regression for Ordinal Responses');
[B,dev,stats] = mnrfit(X,dr_grades,'model','ordinal','link','logit');
disp('Betas');
[B(1:length(unique_grades)-1)'; repmat(B(length(unique_grades):end),1,length(unique_grades)-1)]
disp('p values');
[stats.p(1:length(unique_grades)-1)'; repmat(stats.p(length(unique_grades):end),1,length(unique_grades)-1)]

% Multinomial Regression for Hierarchical Responses
% X: my design matrix.
% dr_grades: my response 
disp('Multinomial Regression for Hierarchical Responses');
[B,dev,stats] = mnrfit(X,dr_grades,'model','hierarchical','link','logit');
disp('Betas');
B
disp('p values');
stats.p






