
function [n_cap, n_inf, n_corr, r] = compute_fractal_measurements(input_image)

    % compute fractal N and r using typical box-counting strategy
    [n_cap, n_inf, n_corr, r] = boxcount(input_image);

end


