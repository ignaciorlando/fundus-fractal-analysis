
% SCRIPT_ORGANIZE_MESSIDOR_DATA_TO_SELECT_NEOVASCULARIZED_IMAGES
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------

config_organize_messidor_data_to_select_neovascularized_images;

%% prepare folders

% initialize image folder
image_folder = fullfile(dataset_folder, 'images');
% initialize labels folder
labels_folder = fullfile(dataset_folder, 'labels');

%% retrieve image names and labels

% retrieve all filenames 
filenames = getMultipleImagesFileNames(image_folder);
% load labels
load(fullfile(labels_folder, 'labels.mat'));

%% get only the R3 images and initialize an Excel file with the names

% get first all the ids of images with high risk of blindness
images_with_high_risk = filenames(labels.dr==3);

% initialize a new folder with high risk images
mkdir(dataset_folder, 'r3-images');
for i = 1 : length(images_with_high_risk)
    copyfile(fullfile(image_folder, images_with_high_risk{i}), fullfile(dataset_folder, 'r3-images', images_with_high_risk{i}));
end

% get sorted filenames
images_with_high_risk = getMultipleImagesFileNames(fullfile(dataset_folder, 'r3-images'));

% prepare the data to write on the Excel file
to_write_on_file = cell(length(images_with_high_risk)+1, 2);
to_write_on_file{1, 1} = 'Image filename'; 
to_write_on_file{1, 2} = 'Proliferative DR label';
to_write_on_file(2:end, 1) = images_with_high_risk';

xlswrite(fullfile(dataset_folder, 'labels.xls'), to_write_on_file);