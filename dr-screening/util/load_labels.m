
function labels = load_labels(data_path, problem_to_solve)

    % load labels
    current_labels = load(fullfile(data_path, 'labels', 'labels.mat'));
    
    % reassign current_labels.labels.dr to the variable to return
    labels = current_labels.labels.dr;
    
    % now, depending on the problem we want to solve, we will adapt the
    % labels
    switch problem_to_solve
        case 'dr-screening'
            % R0 = -1, R1-R2-R3-R4 = 1
            labels = 2 * (labels > 0) - 1;
        case 'need-to-referral'
            % R0,R1 = -1, R2-R3-R4 = 1
            labels = 2 * (labels > 1) - 1;
        case 'proliferative'
            % R0,R1,R2,R3 = -1, R4 = 1
            labels = 2 * (labels > 3) - 1;
        case 'od-neovascularizations'
            % RO,R1,R2,R3,R4 = -1, R5 = 1
            labels = 2 * (labels > 4) - 1;
        otherwise
            error(['problem_to_solve unknown. "dr-screening", "need-to-referral", "proliferative" or "od-neovascularizations" expected, ', problem_to_solve, ' found.']);
    end

end