
function [n_cap, n_inf, n_corr, r] = compute_fractal_measurements(input_image)

    % if the image is logical...
    if islogical(input_image)
        
        % compute fractal N and r using typical box-counting strategy
        [n_cap, n_inf, n_corr, r] = boxcount(input_image);
        
    % if the image is not logical...
    else
    
        % compute using Reuter implementation
        [n_cap, n_inf, n_corr, r] = getFD(input_image);

    end

end


