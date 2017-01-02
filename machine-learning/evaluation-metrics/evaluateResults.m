
function [quality] = evaluateResults(labels, scores, measure)
% evaluateResults Given a string 'measure' indicating a measure to evaluate
% binary classifications, this function computes it using 'labels' as
% ground truth and 'scores' to estimate the corresponding labels.
% INPUT: labels = ground truth labelling
%        scores = likelihood of belonging to the positive class
%        measure = string indicating the performance measure that is going
%        to be computed
%           .auc = area under the roc curve
%           .acc = accuracy
% OUTPUT: quality = quality measure indicated in the 'measure' string

    quality = -Inf;
    if (size(labels,1) > size(labels,2))
        labels = labels';
    end
    
    % Area under the ROC curve
    if (strcmp(measure, 'auc'))
        
        [~, ~, info] = vl_roc(labels, scores);
        quality = info.auc;
        
    % Accuracy
    elseif (strcmp(measure, 'acc'))
        
        quality = length(find(sign(scores)==labels))/length(labels);
        
    % G-mean
    elseif (strcmp(measure, 'g-mean')) || (strcmp(measure, 'f1-score'))

        C = confusionmat(int8(labels), int8(scores>0));
        TP = double(C(2,2));
        FN = double(C(2,1));
        TN = double(C(1,1));
        FP = double(C(1,2));
        
        if (strcmp(measure, 'g-mean'))
            Se = TP / (TP + FN);
            Sp = TN / (TN + FP);
            quality = sqrt(Se * Sp);
        else
            Pr = TP / (TP + FP + eps);
            Re = TP / (TP + FN + eps);
            quality = 2 * (Pr * Re) / (Pr + Re + eps);
        end
            
        
    elseif (strcmp(measure, 'overall-accuracy'))
        
        C = confusionmat(int8(labels), int8(scores))
        quality = trace(C) / sum(C(:));
        
    end

end
