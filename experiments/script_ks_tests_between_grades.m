
% SCRIPT_WILK_TESTS_BETWEEN_GRADES
% -------------------------------------------------------------------------
% This script runs a bunch of Wilcoxon rank sum tests between different DR 
% grades in order to determine if fractal dimensions differ and are 
% discriminative enough.
% -------------------------------------------------------------------------

close all
clear all
config_ks_tests_between_grades

%% prepare paths and load labels

% initialize the input folder
input_folder = fullfile(dataset_path, dataset_name, 'features');

% load labels
load(fullfile(dataset_path, dataset_name, 'labels', 'labels.mat'));

% identify unique grades
labels.dr(labels.dr>4) = 4;
unique_grades = unique(labels.dr);

%% performe multiple ANOVA tests

% print image source
fprintf('\n----------------------------\n');
disp(image_source);
disp('----------------------------');

% initialize an array of p-values
p_values = zeros(length(list_of_fractal_dimensions), length(unique_grades)-1);

% for each fractal dimension
for i = 1 : length(list_of_fractal_dimensions)
    
    % get current fractal dimension
    current_fractal_dimension = list_of_fractal_dimensions{i};
    fprintf('\n%s dimension\n', current_fractal_dimension);
    
    % load features
    load(fullfile(input_folder, strcat(current_fractal_dimension, '-', image_source, '.mat')));
    
    % for each grade
    for r_i = 1 : length(unique_grades) - 1
        
        % get source grade
        R_i = unique_grades(r_i);
        
        % for each grade from r_i
        for r_j = r_i + 1 : length(unique_grades)
            
            % get the other grade
            R_j = unique_grades(r_j);

            % run anova test
            %[p_values(i, r_i), h] = ranksum(features(labels.dr==R_i), features(labels.dr==R_j));
            [h, p_values(i, r_i)] = kstest2(features(labels.dr==R_i), features(labels.dr==R_j), 'alpha', 0.05);

            % print statistics on screen if p value is smaller than 0.05
            if h==1
                fprintf('R%d vs R%d: H0 rejected, medians significantly different, p-value=%0.1e\n', ...
                   R_i, R_j, ...
                   p_values(i, r_i));
            else
                fprintf('R%d vs R%d: Cannot reject H0, medians are not significantly different, p-value=%0.1e\n', ...
                   R_i, R_j, ...
                   p_values(i, r_i));
            end
            close all
        
        end
        fprintf('\n');
        
    end
    
end