
function [segm] = preprocess_segmentation(segm)

    % get structures with more than 100 pixels
    segm = bwareaopen(segm, 100);
    % apply a closing to compensate error in the central reflex
    segm = imclose(segm, strel('disk',2,8));
    % get structures with more than 200 pixels
    segm = bwareaopen(segm, 200);
    
end