
function [FDcap, FDinf, FDcor] = compute_fractal_dimensions(input_image)

    % compute fractal measurements
    [n_cap, n_inf, n_corr, r] = compute_fractal_measurements(input_image);

    % if the image is logical...
    if islogical(input_image)
        
        % estimate FDcap as the slope of the regression curve
        X = cat(2, ones(size(r')), log(r'));
        Y = log(n_cap');
        B = regress(Y,X);
        FDcap = -B(2);
        
        % estimate FDinf as the slope of the regression curve
        X = cat(2, ones(size(r(2:end)')), log(r(2:end)'));
        Y = n_inf';
        B = regress(Y,X);
        FDinf = -B(2);        
        
        % estimate FDcor as the slope of the regression curve
        X = cat(2, ones(size(r(2:end)')), log(r(2:end)'));
        Y = log(n_corr');
        B = regress(Y,X);
        FDcor = -B(2); 
        
    % if the image is not logical...
    else
        
        X = cat(2, ones(size(r)), log(r));

        % estimate FDcap as the slope of the regression curve
        Y = -log(n_cap);
        [B,BINT,R,RINT, STATS] = regress(Y,X);
        FDcap = B(2);

        % estimate FDinf as the slope of the regression curve
        Y = n_inf;
        [B,BINT,R,RINT, STATS] = regress(Y,X);
        FDinf = B(2);

        % estimate FDcor as the slope of the regression curve
        Y = log(n_corr);
        [B,BINT,R,RINT, STATS] = regress(Y,X);
        FDcor = B(2);

        
    end

end


