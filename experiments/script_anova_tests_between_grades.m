
% SCRIPT_ANOVA_TESTS_BETWEEN_GRADES
% -------------------------------------------------------------------------
% This script runs a bunch of ANOVA tests between different DR grades in
% order to determine if fractal dimensions differ and are discriminative
% enough.
% -------------------------------------------------------------------------

close all
clear all
%clc
config_anova_tests_between_grades

%% prepare paths and load labels

% initialize the input folder
input_folder = fullfile(dataset_path, dataset_name, 'features');

% load labels
load(fullfile(dataset_path, dataset_name, 'labels', 'labels.mat'));

% identify unique grades
unique_grades = unique(labels.dr);

%% performe multiple ANOVA tests

% print image source
fprintf('\n----------------------------\n');
disp(image_source);
disp('----------------------------');

% for each fractal dimension
for i = 1 : length(list_of_fractal_dimensions)
    
    % get current fractal dimension
    current_fractal_dimension = list_of_fractal_dimensions{i};
    fprintf('\n%s dimension\n', current_fractal_dimension);
    
    % load features
    load(fullfile(input_folder, strcat(current_fractal_dimension, '-', image_source, '.mat')));
    
    % for each grade
    for r_i = 1 : length(unique_grades) - 1
        
        % get grade to threshold
        R_i = unique_grades(r_i);
        % get remaining grades
        smaller_grades = unique_grades(unique_grades <= R_i);
        remaining_grades = unique_grades(unique_grades > R_i);
        % get current configuration of labels
        current_labels = (labels.dr > R_i);
        
        % run anova test
        [p, tbl, stats] = anova1(features, current_labels);
        
        % print statistics on screen if p value is smaller than 0.05
        if p < 0.05
            fprintf('\tR%s < R%s \t\t Mean difference: %d \t p-value: %d\n', ...
                mat2str(smaller_grades), mat2str(remaining_grades), ...
                stats.means(1) - stats.means(2), ...
                p);
        else
            fprintf('\tR%s < R%s \t\t p-value is too big: %d\n', ...
                mat2str(smaller_grades), mat2str(remaining_grades), ...
                p);
        end
        close all
        
    end
    
end