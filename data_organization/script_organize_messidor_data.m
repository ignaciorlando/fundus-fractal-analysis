
% SCRIPT_ORGANIZE_MESSIDOR_DATA
% -------------------------------------------------------------------------
% This script is used to organize MESSIDOR data. You must modify
% config_organize_messidor_data before executing this script.
% -------------------------------------------------------------------------

config_organize_messidor_data

%% prepare folders

% prepare paths from the original data set 
main_messidor_folder = fullfile(root_folder, 'MESSIDOR', 'images');

% prepare paths for the outputs
main_messidor_folder_output = fullfile(output_folder, 'MESSIDOR', 'images');
mkdir(main_messidor_folder_output);

%% copy files

% copying images
fprintf('Copying images...\n');

% iterate on each of the hospital folders to copy all the files
 hospital_folders = getOnlyFolders(main_messidor_folder);
for i = 1 : length(hospital_folders)
    
    % get all the subfolders from this hospital
    current_subfolder = fullfile(main_messidor_folder, hospital_folders{i});
    sub_base_folders = getOnlyFolders(current_subfolder);
    
    % for each of the basis
    for j = 1 : length(sub_base_folders)
        
        % get current sub base folder
        current_base = fullfile(current_subfolder, sub_base_folders{j});
        % get all images on current base
        image_names = getMultipleImagesFileNames(current_base);
        % copy each image to the new folder
        for k = 1 : length(image_names)
            % retrieve the first part of the name
            [~, current_image_name, ext] = fileparts(image_names{k}) ;
            if (strcmpi(ext, '.jpg') || strcmpi(ext, '.jpeg'))
                ext = '.png';
            end
            % copy the file, changing the extension to PNG if the image in in
            % JPG format
            if ~strcmp(ext, '.xls')
                copyfile(fullfile(current_base, image_names{k}), fullfile(main_messidor_folder_output, strcat(current_image_name, ext)));
            end
        end
        
    end
    
end


%% prepare labels

fprintf('Preparing and organizing labels...\n');

% retrieve all image names from XLS files, and both dr and macular edema
% labels

% initialize arrays
all.image_filenames = {};
all.dr_labels = [];
all.macular_edema_labels = [];

% for each hospital folder
for i = 1 : length(hospital_folders)
    
    % get all the XLS files from this hospital
    xls_filenames = dir(fullfile(main_messidor_folder, hospital_folders{i}, '*.xls'));
    xls_filenames = {xls_filenames.name};
    
    % for each excel file
    for j = 1 : length(xls_filenames)
        % read the XLS file
        [num,txt,~] = xlsread(fullfile(main_messidor_folder, hospital_folders{i}, xls_filenames{j}));
        % retrieve image filenames
        txt = txt(2:end,1);
        % concatenate current labels and filenames in the all arrays
        all.image_filenames = cat(1, all.image_filenames, txt);
        all.dr_labels = cat(1, all.dr_labels, num(:,1));
        all.macular_edema_labels = cat(1, all.macular_edema_labels, num(:,2));
    end
    
end

% now we have all labels... what we want is to assign each label to the
% corresponding images as they are read from disk in the new folder

% retrieve image
image_names = getMultipleImagesFileNames(main_messidor_folder_output);

% initialize the array of labels
labels.dr = zeros(length(image_names), 1);
labels.edema = zeros(length(image_names), 1);

% for each of the images
for i = 1 : length(image_names)
    
    % retrieve image idx
    idx = find(strcmp(all.image_filenames, image_names{i}));
    % assign labels
    labels.dr(i) = all.dr_labels(idx);
    labels.edema(i) = all.macular_edema_labels(idx);
    
end

% save labels
main_messidor_folder_labels_output = fullfile(output_folder, 'MESSIDOR', 'labels');
mkdir(main_messidor_folder_labels_output);
save(fullfile(main_messidor_folder_labels_output, 'labels.mat'), 'labels');

%% now, generate fov masks
root = fullfile(output_folder, 'MESSIDOR');
threshold = 0.15;
GenerateFOVMasks;

%% crop every mask

if perform_cropping

    % cropping training data set
    fprintf('Cropping data set...\n');
    % - path where the images to crop are
    sourcePaths = { ...
        fullfile(output_folder, 'MESSIDOR', 'images'), ...
    };
    % - paths where the images to be cropped will be saved
    outputPaths = { ...
        fullfile(output_folder, 'MESSIDOR', 'images'), ...   
    };
    % - masks to be used to crop the images
    maskPaths = fullfile(output_folder, 'MESSIDOR', 'masks');
    % crop!!
    script_cropFOVSet;
    
end
