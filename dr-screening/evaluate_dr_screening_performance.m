
function [mean_tpr, mean_fpr, mean_auc, std_auc, std_tpr] = evaluate_dr_screening_performance(folds, scores)

    all_tpr = [];
    all_fpr = [];
    all_aucs = zeros(size(folds));
    
    % for each of the folds
    for i = 1 : length(folds)
        
        % evaluate performance on this folds
        [tpr, tnr, info] = vl_roc(folds{i}.test_data.labels, scores{i});
        
        % concatenate tpr and fpr values
        if (isempty(all_tpr))
            all_tpr = cat(2, all_tpr, tpr');
            all_fpr = cat(2, all_fpr, 1-tnr');
        else
            all_tpr = cat(2, all_tpr, tpr(1:size(all_tpr,1))');
            all_fpr = cat(2, all_fpr, 1-tnr(1:size(all_fpr,1))');
        end
        all_aucs(i) = info.auc;
        
    end
    
    % take the mean value of each indicator
    mean_tpr = mean(all_tpr, 2);
    mean_fpr = mean(all_fpr, 2);
    mean_auc = mean(all_aucs);
    
    % get standard deviation of the TPR
    std_tpr = std(all_tpr, 1, 2);
    
    % get AUC standard deviation
    std_auc = std(all_aucs);

end